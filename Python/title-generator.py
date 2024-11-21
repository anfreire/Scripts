import argparse
import pyperclip

DEFAULT_WIDTH = 80

DEFAULT_HEIGHT = 3
POSSIBLE_HEIGHTS = (3, 5)


def copy_to_clipboard(generated_title: str):
    pyperclip.copy(generated_title)


def generate_title_comment(
    title: list[str],
    width: int = DEFAULT_WIDTH,
    height: int = DEFAULT_HEIGHT,
    upper: bool = None,
    alt_style: bool = None,
):
    title_str = " ".join(title)

    if upper:
        title_str = title_str.upper()

    if alt_style:
        top_line = "#" * width

        middle_line = "#" + title_str.center(width - 2) + "#"

        bottom_line = top_line

        padding = "#" + " " * (width - 2) + "#"
    else:
        top_line = "/**" + "*" * (width - 4) + " "

        middle_line = " *" + title_str.center(width - 4) + "* "

        bottom_line = " " + "*" * (width - 3) + "*/"

        padding = " *" + " " * (width - 4) + "* "

    if height == 3:
        lines = [top_line, middle_line, bottom_line]
    else:
        lines = [top_line, padding, middle_line, padding, bottom_line]

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(
        description="Generate a title in a code comment style.",
    )

    parser.add_argument("title", type=str, nargs="+", help="The title to be generated")
    parser.add_argument(
        "-x",
        "--width",
        type=int,
        default=DEFAULT_WIDTH,
        help="The width of the comment",
    )
    parser.add_argument(
        "-y",
        "--height",
        type=int,
        default=DEFAULT_HEIGHT,
        choices=POSSIBLE_HEIGHTS,
        help="The height of the comment",
    )
    parser.add_argument(
        "-u",
        "--upper",
        action="store_true",
        help="Convert title to uppercase",
    )
    parser.add_argument(
        "-a",
        "--alt",
        action="store_true",
        help="Use alternative comment style",
    )

    args = parser.parse_args()

    comment = generate_title_comment(
        args.title, args.width, args.height, args.upper, args.alt
    )
    print(comment)
    copy_to_clipboard(comment)


if __name__ == "__main__":
    main()
