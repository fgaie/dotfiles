#!/usr/bin/env python

import functools
import operator
from sys import argv
from pathlib import Path
from typing import TypeVar


T = TypeVar("T")
def flatten(l: list[list[T]]) -> list[T]:
    return functools.reduce(operator.iconcat, l, [])


def get_dirs(root: Path, name: str) -> list[Path]:
    if '*' in name:
        return [ dir.expanduser().resolve() for dir in root.glob(name) if dir.is_dir() ]
    elif (root/name).exists():
        return [ (root/name).expanduser().resolve() ]
    else:
        return [ Path(name).expanduser().resolve() ]


def find_from(root: Path, ignore: bool = False) -> list[Path]:
    res = []

    if not ignore:
        res.append(root)

    projects_file = root / ".projects"
    if projects_file.exists():
        with open(projects_file, "r") as f:
            dirs = flatten([ get_dirs(root, dir.strip()) for dir in f ])
            res += flatten([ find_from(dir) for dir in dirs ])

    return res


def main(argv: list[str]):
    root = Path(argv[0]).resolve().parent
    res = find_from(root, ignore = True)

    for dir in res:
        print(dir)


if __name__ == "__main__":
    main(argv)
