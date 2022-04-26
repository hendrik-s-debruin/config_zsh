#!/usr/bin/env python3

#  ================================== Imports ============================== {{{
from __future__ import annotations
import os
import git
import sys
from typing import List
# }}}

#  ================================== Colors =============================== {{{
black = "\033[0;30m"
red = "\033[0;31m"
green = "\033[0;32m"
yellow = "\033[0;33m"
blue = "\033[0;34m"
magenta = "\033[0;35m"
cyan = "\033[0;36m"
white = "\033[0;37m"
bright_black = "\033[0;90m"
bright_red = "\033[0;91m"
bright_green = "\033[0;92m"
bright_yellow = "\033[0;93m"
bright_blue = "\033[0;94m"
bright_magenta = "\033[0;95m"
bright_cyan = "\033[0;96m"
bright_white = "\033[0;97m"

reset = "\033[0m"
# }}}

#  ================================ PromptEntry ============================ {{{
class PromptEntry:
    def __init__(self, entry: str, color: str = bright_white):
        self.entry: str = color + entry + reset
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
    if get_success():
        color = bright_green
    else:
        color = bright_red
    return PromptEntry("λ", color)


# TODO do not duplicate code with prompt_git_icon
def prompt_git() -> PromptEntry:
    try:
        repo = git.Repo(os.getcwd())
        branch_name = repo.active_branch.name
        if repo.is_dirty():
            color = bright_red
        else:
            color = green
        return PromptEntry(branch_name, color)

    except git.InvalidGitRepositoryError:
        return PromptEntry("")


# TODO do not duplicate code with prompt_git
def prompt_git_icon() -> PromptEntry:
    try:
        repo = git.Repo(os.getcwd())
        if repo.is_dirty():
            color = bright_red
        else:
            color = green
        return PromptEntry("", color)

    except git.InvalidGitRepositoryError:
        return PromptEntry("")


def prompt_user() -> PromptEntry:
    if get_success():
        return PromptEntry(os.getlogin())
    else:
        return PromptEntry(os.getlogin(), red)


def prompt_host() -> PromptEntry:
    if get_success():
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

    return PromptEntry("", white)


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
        self._add_element(prompt_git_icon(), 1)
        self._add_element(prompt_git(), 6)
        self._add_element(prompt_venv_icon(), 2)
        self._add_element(prompt_venv(), 3)
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

#  ============================= Argument Passing ========================== {{{
# TODO improve this hacky argument passing
def get_cols() -> int:
    try:
        return int(sys.argv[1])
    except:
        return 100


def get_success() -> bool:
    try:
        return int(sys.argv[2]) == 0
    except:
        return False
# }}}

#  ============================ Interactive Testing ======================== {{{
def demo():
    prompt_builder = PromptLayoutEngine()
    for i in range(100, 0, -1):
        print(prompt_builder.build_prompt(i))
# }}}

#  =================================== main ================================ {{{
if __name__ == "__main__":
    prompt_builder = PromptLayoutEngine()
    print(prompt_builder.build_prompt(get_cols()))
# }}}
