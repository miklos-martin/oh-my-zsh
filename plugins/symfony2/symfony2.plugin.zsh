# Symfony2 basic command completion
# And one step further

: ${SYMFONY_COMPLETE_CONSOLE:=""}
: ${SYMFONY_COMPLETE_ENTITIES:=""}

_SYMFONY_COMPLETE_CONSOLE=(
    ./console
    app/console
)

SYMFONY_DO_COMPLETE_CONSOLE=($_SYMFONY_COMPLETE_CONSOLE $SYMFONY_COMPLETE_CONSOLE)

_SYMFONY_COMPLETE_ENTITIES=(
    doctrine:generate:crud
    doctrine:generate:entities
    doctrine:generate:form
    generate:doctrine:crud
    generate:doctrine:entities
    generate:doctrine:form
)

SYMFONY_DO_COMPLETE_ENTITIES=($_SYMFONY_COMPLETE_ENTITIES $SYMFONY_COMPLETE_ENTITIES)

_symfony2 ()
{
    local console=$words[1]
    
    if [ ! -f "$console" ];then
        return
    fi

    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        ':command:->command' \
        '*::options:->options'

    case $state in
        (command)
            if [ -z "$symfony2_command_list" ];then
                _symfony2_command_list=$(_symfony2_get_command_list $console)
            fi
            compadd "$@" $(echo $_symfony2_command_list)
        ;;

        (options)
            needle=$line[1]
            if [[ ${SYMFONY_DO_COMPLETE_ENTITIES[(i)$needle]} -le ${#SYMFONY_DO_COMPLETE_ENTITIES} ]]; then
                if [ -z "$symfony2_entity_list" ];then
                    _symfony2_entity_list=$(_symfony2_get_entity_list $console)
                fi
                compadd "$@" $(echo $_symfony2_entity_list)
            else
            fi
        ;;
    esac
}

_symfony_console () {
  echo "php $(find . -maxdepth 2 -mindepth 1 -name 'console' -type f | head -n 1)"
}

_symfony2_get_command_list () {
   `_symfony_console` --no-ansi | sed "1,/Available commands/d" | awk '/^  ?[^ ]+ / { print $1 }'
}

_symfony2 () {
   compadd `_symfony2_get_command_list`
}

compdef _symfony2 '`_symfony_console`'
compdef _symfony2 'app/console'
compdef _symfony2 'bin/console'
compdef _symfony2 sf

#Alias
alias sf='`_symfony_console`'
alias sfcl='sf cache:clear'
alias sfsr='sf server:run -vvv'
alias sfcw='sf cache:warmup'
alias sfroute='sf router:debug'
alias sfcontainer='sf container:debug'
alias sfgb='sf generate:bundle'
