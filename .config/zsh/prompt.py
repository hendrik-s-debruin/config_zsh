#!/usr/bin/env python3

#  ================================== Imports ============================== {{{
from __future__ import annotations
import os
import git
import random
import subprocess
from typing import List
from argparse import ArgumentParser, Namespace
# }}}

#  ================================== Colors =============================== {{{
class Color:
    def __init__(self, code: str):
        self._code = code

    def apply(self, text: str) -> str:
        return '%{' + self._code + '%}' + text

black          =  Color("\033[30m")
red            =  Color("\033[31m")
green          =  Color("\033[32m")
yellow         =  Color("\033[33m")
blue           =  Color("\033[34m")
magenta        =  Color("\033[35m")
cyan           =  Color("\033[36m")
white          =  Color("\033[37m")
bright_black   =  Color("\033[90m")
bright_red     =  Color("\033[91m")
bright_green   =  Color("\033[92m")
bright_yellow  =  Color("\033[93m")
bright_blue    =  Color("\033[94m")
bright_magenta =  Color("\033[95m")
bright_cyan    =  Color("\033[96m")
bright_white   =  Color("\033[97m")
# }}}

#  ================================ PromptEntry ============================ {{{
class PromptEntry:
    def __init__(self, entry: str, color: Color = bright_white):
        self.entry: str = color.apply(entry)
        self.len: int = len(entry)

def prompt_cwd() -> PromptEntry:
    """
    Return the top two directories of the current path.
    """
    cwd = os.getcwd()
    home = os.path.expanduser("~")

    if cwd.startswith(home):
        cwd = cwd.replace(home, "~", 1)

    # Find the top two directories and store them in the tail variables
    (head, tail) = os.path.split(cwd)
    (head2, tail2) = os.path.split(head)

    if head2 == "/":
        # If we are close to root, display that
        cwd = os.path.join(head2, tail2, tail)
    else:
        # Else, just display the top two directories
        cwd = os.path.join(tail2, tail)

    return PromptEntry(" " + cwd, yellow)


def prompt_char() -> PromptEntry:
    if last_command_successful():
        color = bright_green
    else:
        color = bright_red
    return PromptEntry("λ", color)


# TODO do not duplicate code with prompt_git_icon
def prompt_git() -> PromptEntry:
    try:
        repo = git.Repo(os.getcwd(), search_parent_directories=True)
        branch_name = repo.active_branch.name
        if repo.is_dirty():
            color = bright_red
        else:
            color = green
        return PromptEntry(branch_name, color)

    except git.InvalidGitRepositoryError:
        return PromptEntry("")

    # Something bad happend with the Repo instantiation. Seems to happen in
    # submodules and maybe rebasing or merging? TODO: figure out if this can be
    # fixed
    except Exception:
        return PromptEntry("[!]", magenta)


# TODO do not duplicate code with prompt_git
def prompt_git_icon() -> PromptEntry:
    try:
        repo = git.Repo(os.getcwd(), search_parent_directories=True)
        if repo.is_dirty():
            color = bright_red
        else:
            color = green
        return PromptEntry("", color)

    except git.InvalidGitRepositoryError:
        return PromptEntry("")

# TODO do not duplicate git code
def prompt_git_hash() -> PromptEntry:
    try:
        repo = git.Repo(os.getcwd(), search_parent_directories=True)
        hash = repo.head.object.hexsha[0:7]
        if repo.is_dirty():
            color = bright_red
        else:
            color = green
        return PromptEntry(hash, color)
    except git.InvalidGitRepositoryError:
        return PromptEntry("")

def prompt_git_tag() -> PromptEntry:
    try:
        repo = git.Repo(os.getcwd(), search_parent_directories=True)
        hash = repo.head.object.hexsha
        tags = repo.tags
        tags = ", ".join([tag.name for tag in tags if tag.commit.hexsha == hash])
        if repo.is_dirty():
            color = bright_red
        else:
            color = green
        return PromptEntry(tags, color)

    except git.InvalidGitRepositoryError:
        return PromptEntry("")


def prompt_user() -> PromptEntry:
    if last_command_successful():
        return PromptEntry(os.getlogin())
    else:
        return PromptEntry(os.getlogin(), red)


def prompt_host() -> PromptEntry:
    if last_command_successful():
        return PromptEntry("@ " + os.uname()[1])
    else:
        return PromptEntry("@ " + os.uname()[1], red)

def prompt_venv() -> PromptEntry:
    venv = os.environ.get("VIRTUAL_ENV")

    if venv is None:
        return PromptEntry("")

    return PromptEntry(os.path.basename(venv), white)

def prompt_venv_icon() -> PromptEntry:
    venv = os.environ.get("VIRTUAL_ENV")

    if venv is None:
        return PromptEntry("")

    entry = ""
    try:
        version = subprocess.check_output(["python", "--version"]).decode("utf-8").strip()
        version = version.replace("Python ", "")
        entry = entry + " (" + version + ")"
    except:
        pass

    return PromptEntry(entry, white)

def prompt_jobs() -> PromptEntry:
    jobs = get_job_count()

    if jobs == 0:
        return PromptEntry("")

    return PromptEntry(f"[{jobs}]", yellow)

def prompt_emoji() -> PromptEntry:
    if last_command_successful():
        return PromptEntry("")

    with open(os.path.expanduser("~/.config/zsh/prompt_on_error")) as f:
        icons = f.readlines()
        icon = icons[random.randrange(len(icons))].strip()
        return PromptEntry(icon, red)

def prompt_bookmark() -> PromptEntry:
    try:
        with open(os.path.expanduser("~/.config/zsh/bookmarks")) as f:
            lines = f.readlines()
            cwd = os.getcwd()
            for line in lines:
                bookmark, location = line.strip().split(":", 1)
                if cwd == location:
                    return PromptEntry(" " + bookmark)
    except:
        pass

    return PromptEntry("")

def prompt_exit_code() -> PromptEntry:
    exit_code = last_exit_code()
    if exit_code == 0:
        return PromptEntry("")
    else:
        return PromptEntry("[" + str(exit_code) + "]", red)


# }}}

#  ================================== Layout =============================== {{{
class PromptLayoutEngine:
    class PromptSection:
        def __init__(self, entry: PromptEntry, position: int, priority: int):
            self.entry = entry
            self.position = position
            self.priority = priority
            self.active = True

    def __init__(self):
        self.elements: List[PromptLayoutEngine.PromptSection] = []

        self._add_element(prompt_user(), 4)
        self._add_element(prompt_host(), 7)
        self._add_element(prompt_cwd(), 5)
        self._add_element(prompt_bookmark(), 9)
        self._add_element(prompt_git_icon(), 1)
        self._add_element(prompt_git_hash(), 12)
        self._add_element(prompt_git_tag(), 11)
        self._add_element(prompt_git(), 6)
        self._add_element(prompt_venv_icon(), 2)
        self._add_element(prompt_venv(), 3)
        self._add_element(prompt_jobs(), 7)
        self._add_element(prompt_emoji(), 8)
        self._add_element(prompt_exit_code(), 10)
        self._add_element(prompt_char(), 0)

        self.elements = list(filter(lambda x: x.entry.len > 0, self.elements))

    def _add_element(self, element: PromptEntry, priority: int):
        self.elements.append(
            PromptLayoutEngine.PromptSection(element, len(self.elements), priority)
        )

    # TODO find a better algorithm if this one does not perform well enough
    def build_prompt(self, available_cols: int):
        self.elements = sorted(self.elements, key=lambda x: x.priority)

        while self._find_prompt_len(self.elements) > available_cols:
            self.elements.pop()

        self.elements = sorted(self.elements, key=lambda x: x.position)

        prompt: str = ""
        for element in self.elements:
            prompt += element.entry.entry + " "

        return prompt

    def _find_prompt_len(
        self, prompt_entries: List[PromptLayoutEngine.PromptSection]
    ) -> int:
        length = 0

        for element in prompt_entries:
            length += element.entry.len
        length += len(prompt_entries)  # spaces between entries

        return length
# }}}

#  ============================ Interactive Testing ======================== {{{
def demo():
    prompt_builder = PromptLayoutEngine()
    for i in range(100, 0, -1):
        print(prompt_builder.build_prompt(i))
# }}}

#  =================================== main ================================ {{{

#  ============================= Argument Passing ========================== {{{

args: Namespace = Namespace()

def get_cols() -> int:
    return args.cols

def last_command_successful() -> bool:
    return args.success_code == 0

def get_job_count() -> int:
    return args.jobs

def last_exit_code() -> int:
    return args.success_code

# }}}

if __name__ == "__main__":
    try:
        parser = ArgumentParser()
        parser.add_argument("--cols",         type=int, required=True)
        parser.add_argument("--success_code", type=int, required=True)
        parser.add_argument("--jobs",         type=int, required=True)
        args = parser.parse_args()

        prompt_builder = PromptLayoutEngine()
        print(prompt_builder.build_prompt(get_cols()))

    except Exception as e:
        # Fallback emergency prompt in case of error in the script
        print(f"Error: {e}")
        print("\n[zsh] > ")

    except: # Argparse throws its own thing apparently
        print("\n[zsh] > ")

# }}}
