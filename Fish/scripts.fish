function scripts
    set -l SCRIPTS_DIR "$HOME/Documents/Scripts"
    set -l PYTHON_SCRIPTS_DIR "$SCRIPTS_DIR/Python"
    set -l BASH_SCRIPTS_DIR "$SCRIPTS_DIR/Bash"

    set bash_scripts (find $BASH_SCRIPTS_DIR -type f -name "*.sh")
    set python_scripts_main (find $PYTHON_SCRIPTS_DIR -maxdepth 1 -type f -name "*.py" ! -name "__main__.py")
    set python_folders (find $PYTHON_SCRIPTS_DIR -mindepth 1 -maxdepth 1 -type d -exec test -e '{}'/__main__.py \; -print)

    set all_items $bash_scripts $python_scripts_main $python_folders

    set selected_item (printf '%s\n' $all_items | fzf)

    if test -n "$selected_item"

        switch $selected_item
            case "*.py"
                python3 $selected_item $argv
            case "*.sh"
                $selected_item $argv
            case "*"
                if test -d $selected_item
                    set module_name (basename $selected_item)
                    pushd $PYTHON_SCRIPTS_DIR
                    python3 -m $module_name $argv
                    popd
                else
                    echo "Unknown item type: $selected_item"
                end
        end
    else
        echo "No item selected."
    end
end