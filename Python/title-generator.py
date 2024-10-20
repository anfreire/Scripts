import argparse
import pyperclip


def copy_to_clipboard(text):
    pyperclip.copy(text)


def generate_comment(title, width, upper, height, alt_style):
    title = title.upper() if upper else title
    if alt_style:
        border = "#" * width
        padding = "#" + " " * (width - 2) + "#"
        title_line = "#" + title.center(width - 2) + "#"
    else:
        border = "/**" + "*" * (width - 3)
        padding = " *" + " " * (width - 3) + "*"
        title_line = " *" + title.center(width - 3) + "*"
        border_end = " *" + "*" * (width - 3) + "*/"

    lines = [border, title_line, border if alt_style else border_end]

    if height == 5:
        lines.insert(1, padding)
        lines.insert(3, padding)

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(
        description="Generate a title in a code comment style.",
    )

    parser.add_argument("title", type=str, help="The title to be generated")
    parser.add_argument(
        "-x", "--width", type=int, default=80, help="The width of the comment"
    )
    parser.add_argument(
        "-y",
        "--height",
        type=int,
        default=3,
        choices=[3, 5],
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

    comment = generate_comment(args.title, args.width, args.upper, args.height, args.alt)
    print(comment)
    copy_to_clipboard(comment)


if __name__ == "__main__":
    main()