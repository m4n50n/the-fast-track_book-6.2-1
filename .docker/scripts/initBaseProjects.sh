#!/bin/bash

#####################################################################################
###   _       _ _   ____                 _____                           _        ###
###  (_)     (_) | |  _ \               |  __ \                         | |       ###
###   _ _ __  _| |_| |_) | __ _ ___  ___| |__) | __ ___  _   _  ___  ___| |_ ___  ###
###  | | '_ \| | __|  _ < / _` / __|/ _ \  ___/ '__/ _ \| | | |/ _ \/ __| __/ __| ###
###  | | | | | | |_| |_) | (_| \__ \  __/ |   | | | (_) | |_| |  __/ (__| |_\__ \ ###
###  |_|_| |_|_|\__|____/ \__,_|___/\___|_|   |_|  \___/ \__, |\___|\___|\__|___/ ###
###                                                       __/ |                   ###
###                                                      |___/                    ###
#####################################################################################

### author aRodrigoJM ###
# We have try to install the initial base proyects

### PARMS ###
# -c => clean /var/www with exception .docker
# -p projectName => with those params we set the project name
# -t define type project => s = symfony; a = angular; v = vue; r = react
# -b => install base modules for symfony project 
# -v => vervose

# CLEAN=none
# NEWPROYECT=0
# VERVOSE=0

# Mientras el número de argumentos NO SEA 0
CONTADOR=0
PROJECTNAME=""
# TYPE_PROJECT="a" ### => symfony by default | s = symfony, a = angular
for i in $@; do

    CONTADOR=$(expr $CONTADOR + 1)
    # echo "contador $CONTADOR"
    # echo "param $i"

    ### Project name
    if [ -n "$NEWPROJECT_" ]
    then
        if [ -z "$PROJECTNAME" ]
        then
            PROJECTNAME=$i
            echo "PROJECTNAME: $PROJECTNAME"
        fi 
    fi 
    ### Type Project
    if [ -n "$SET_TYPE" ]
    then
        if [ -z "$TYPE_PROJECT" ]
        then
            TYPE_PROJECT=$i
            echo "TYPE_PROJECT: $TYPE_PROJECT"
        fi 
    fi 
    # ### compress
    # if [ -n "$SET_COMPRESS" ]
    # then
    #     if [ -z "$COMPRESS" ]
    #     then
    #         COMPRESS=$i
    #         echo "COMPRESS: $COMPRESS"
    #     fi 
    # fi 

    case "$i" in
    -h|--help)
        # No hacemos nada más, porque showhelp se saldrá del programa
        showhelp
        ;;
    -p|--project)
        NEWPROJECT_="$i"
        echo "NEWPROJECT_: $NEWPROJECT_"
        shift
        ;;
    -t|--type)
        # TYPE="$i"
        SET_TYPE="$i"
        echo "SET_TYPE: $SET_TYPE"
        shift
        ;;
    # -t|--compress)
    #     # TYPE="$i"
    #     SET_TYPE="$i"
    #     echo "COMPRESS: $SET_COMPRESS"
    #     shift
    #     ;;
    -b|--base)
        BASE="$i"
        echo "BASE: $BASE"
        shift
        ;;
    -c|--clean)
        CLEAN="$i"
        echo "CLEAN: $CLEAN"
        shift
        ;;
    -v|--vervose)
        VERVOSE="$i"
        echo "VERVOSE: $VERVOSE"
        shift
        ;;
    *)
    # echo "Argumento no válido"
    # showhelp
    ;;
    esac
    # shift
done

### FUNCTIONS INIT ###

showhelp() {
    echo "Ayuda del programa"
    exit 0
}

### CLEAN INIT ###
CLEANED="0"
cleanProjectPath() {
    if [ $CLEANED = "0" ] 
    then
        if [ -n "$VERVOSE" ]
        then
            echo "Clean /var/www path"
        fi

        cd /var/www
        find . -maxdepth 1 -type f ! -name ".docker" -exec rm {} \;
        find . -maxdepth 1 -type d ! -name ".docker" -exec rm -fr {} \;

        if [ -d "node_modules" ]
        then
            chmod 777 -R node_modules
            rm -fr node_modules
        fi
        CLEANED="1"
    fi
}
# -> CLEAN
if [ -n "$CLEAN" ]
then
    cleanProjectPath
fi
### CLEAN END ###

### CREATE PROJECTS INIT ###

### ANGULAR
createNewProjectAngular() {
    if [ -n "$VERVOSE" ]
    then
        echo "Create new Angular project with name: $PROJECTNAME"
    fi

    cleanProjectPath # clean path

    cd /var/www
    ng new $PROJECTNAME
    npm install @angular-devkit/build-angular
    npm i
    mv $PROJECTNAME/* ../www
    mv $PROJECTNAME/*.* ../www
    # mv $PROJECTNAME/.gitignore ../www
    rm -fr $PROJECTNAME
}

### SYMFONY
createNewProjectSymfony() {

    if [ -n "$VERVOSE" ]
    then
        echo "Create new Symfony project with name: $PROJECTNAME"
    fi

    cleanProjectPath # clean path

    cd /var/www
    symfony new $PROJECTNAME --no-interaction
    mv $PROJECTNAME/* ../www
    mv $PROJECTNAME/.env ../www
    mv $PROJECTNAME/.gitignore ../www
    rm -fr $PROJECTNAME

    if [ -n "$BASE" ]
    then

        if [ -n "$VERVOSE" ]
        then
            echo "Install symfony modules base."
        fi

        ### composer require     
        composer require symfony/flex doctrine/annotations doctrine/orm doctrine/doctrine-bundle doctrine/doctrine-migrations-bundle jms/serializer-bundle lcobucci/jwt lexik/jwt-authentication-bundle nelmio/api-doc-bundle sensio/framework-extra-bundle symfony/asset symfony/console symfony/dotenv symfony/framework-bundle symfony/http-foundation symfony/mime symfony/monolog-bundle symfony/property-access symfony/proxy-manager-bridge symfony/runtime symfony/security-bundle symfony/serializer symfony/twig-bundle symfony/validator symfony/yaml --no-interaction
        
        # composer require symfony/flex --no-interaction 
        # composer require doctrine/annotations --no-interaction 
        # composer require doctrine/orm --no-interaction 
        # composer require doctrine/doctrine-bundle --no-interaction 
        # composer require doctrine/doctrine-migrations-bundle --no-interaction 
        # composer require jms/serializer-bundle --no-interaction 
        # composer require lcobucci/jwt --no-interaction 
        # composer require lexik/jwt-authentication-bundle --no-interaction 
        # composer require nelmio/api-doc-bundle --no-interaction 
        # composer require sensio/framework-extra-bundle --no-interaction 
        # composer require symfony/asset --no-interaction 
        # composer require symfony/console --no-interaction 
        # composer require symfony/dotenv --no-interaction 
        # composer require symfony/framework-bundle --no-interaction 
        # composer require symfony/http-foundation --no-interaction 
        # composer require symfony/mime --no-interaction 
        # composer require symfony/monolog-bundle --no-interaction 
        # composer require symfony/property-access --no-interaction 
        # composer require symfony/proxy-manager-bridge --no-interaction 
        # composer require symfony/runtime --no-interaction 
        # composer require symfony/security-bundle --no-interaction 
        # composer require symfony/serializer --no-interaction 
        # composer require symfony/twig-bundle --no-interaction 
        # composer require symfony/validator --no-interaction 
        # composer require symfony/yaml --no-interaction

        ### dev
        composer require symfony/maker-bundle --dev --no-interaction
        composer require symfony/stopwatch --dev --no-interaction
        composer require symfony/web-profiler-bundle --dev --no-interaction
    fi
    initializeSymfonyProject # init symfony project
}

decompressProject() {
    if [ -n "$VERVOSE" ]
    then
        echo "Descompress project in www"
    fi

    cleanProjectPath # clean path

    if [ $TYPE_PROJECT = "s" ]
    then
        cd /var/www
        7za x .docker/symfonyFiles/compress/symfony.7z
        initializeSymfonyProject # init symfony project
    fi
}

initializeSymfonyProject() {
    if [ -n "$VERVOSE" ]
    then
        echo "Init Project"
    fi
    composer install
    composer update
}

createProject() {
    
    if [ -z "$TYPE_PROJECT" ]
    then
        TYPE_PROJECT="s"
        echo "Default TYPE_PROJECT: $TYPE_PROJECT"
    fi

    ### ANGULAR newProject
    if [ $TYPE_PROJECT = "a" ]
    then
        createNewProjectAngular
    fi
    ### SYMFONY newProject
    else if [ $TYPE_PROJECT = "s" && $PROJECTNAME != "symfony" ] 
        createNewProjectSymfony
    fi
    ## decompress
    else 
        decompressProject # descompress project
    fi
}
### CREATE PROJECTS END ###
### FUNCTIONS END ###

### Exec actions ### ##############

if [ -n "$PROJECTNAME" ]
then
    createProject
fi


### Exec actions ### ##############

















### CREATE PROJECT
# if [ -z "$TYPE_PROJECT" ]
# then
#     TYPE_PROJECT="s"
#     echo "Default TYPE_PROJECT: $TYPE_PROJECT"
# fi

# if [ -n "$TYPE_PROJECT" ]
# then
#     echo "Type project: $TYPE_PROJECT" 

#     ### angular ###
#     if [ $TYPE_PROJECT = "a" ]
#     then
                
#         if [ -n "$PROJECTNAME" ]
#         then

#             if [ -n "$VERVOSE" ]
#             then
#                 echo "Create new Angular project with name: $PROJECTNAME"
#             fi

#             cd /var/www
#             ng new $PROJECTNAME
#             npm install @angular-devkit/build-angular
#             npm i
#             mv $PROJECTNAME/* ../www
#             mv $PROJECTNAME/*.* ../www
#             # mv $PROJECTNAME/.gitignore ../www
#             rm -fr $PROJECTNAME

#         fi

#     fi

#     ### symfony ###
#     if [ $TYPE_PROJECT = "s" ]
#     then    
                
#         if [ -n "$PROJECTNAME" ]
#         then
                
#             if [ $PROJECTNAME != "symfony" ]
#             then

#                 if [ -n "$VERVOSE" ]
#                 then
#                     echo "Create new Symfony project with name: $PROJECTNAME"
#                 fi

#                 cd /var/www
#                 symfony new $PROJECTNAME --no-interaction
#                 mv $PROJECTNAME/* ../www
#                 mv $PROJECTNAME/.env ../www
#                 mv $PROJECTNAME/.gitignore ../www
#                 rm -fr $PROJECTNAME

#                 if [ -n "$BASE" ]
#                 then

#                     if [ -n "$VERVOSE" ]
#                     then
#                         echo "Install symfony modules base."
#                     fi

#                     ### composer require     
#                     composer require symfony/flex doctrine/annotations doctrine/orm doctrine/doctrine-bundle doctrine/doctrine-migrations-bundle jms/serializer-bundle lcobucci/jwt lexik/jwt-authentication-bundle nelmio/api-doc-bundle sensio/framework-extra-bundle symfony/asset symfony/console symfony/dotenv symfony/framework-bundle symfony/http-foundation symfony/mime symfony/monolog-bundle symfony/property-access symfony/proxy-manager-bridge symfony/runtime symfony/security-bundle symfony/serializer symfony/twig-bundle symfony/validator symfony/yaml --no-interaction
                    
#                     # composer require symfony/flex --no-interaction 
#                     # composer require doctrine/annotations --no-interaction 
#                     # composer require doctrine/orm --no-interaction 
#                     # composer require doctrine/doctrine-bundle --no-interaction 
#                     # composer require doctrine/doctrine-migrations-bundle --no-interaction 
#                     # composer require jms/serializer-bundle --no-interaction 
#                     # composer require lcobucci/jwt --no-interaction 
#                     # composer require lexik/jwt-authentication-bundle --no-interaction 
#                     # composer require nelmio/api-doc-bundle --no-interaction 
#                     # composer require sensio/framework-extra-bundle --no-interaction 
#                     # composer require symfony/asset --no-interaction 
#                     # composer require symfony/console --no-interaction 
#                     # composer require symfony/dotenv --no-interaction 
#                     # composer require symfony/framework-bundle --no-interaction 
#                     # composer require symfony/http-foundation --no-interaction 
#                     # composer require symfony/mime --no-interaction 
#                     # composer require symfony/monolog-bundle --no-interaction 
#                     # composer require symfony/property-access --no-interaction 
#                     # composer require symfony/proxy-manager-bridge --no-interaction 
#                     # composer require symfony/runtime --no-interaction 
#                     # composer require symfony/security-bundle --no-interaction 
#                     # composer require symfony/serializer --no-interaction 
#                     # composer require symfony/twig-bundle --no-interaction 
#                     # composer require symfony/validator --no-interaction 
#                     # composer require symfony/yaml --no-interaction

#                     ### dev
#                     composer require symfony/maker-bundle --dev --no-interaction
#                     composer require symfony/stopwatch --dev --no-interaction
#                     composer require symfony/web-profiler-bundle --dev --no-interaction
#                 fi

#                 if [ -n "$VERVOSE" ]
#                 then
#                     echo "Init Project"
#                 fi
#                 composer install
#                 composer update

#             ### DESCOMPRESS PROJECT
#             else
#                 if [ -n "$VERVOSE" ]
#                 then
#                     echo "Descompress project symfony base"
#                 fi

#                 cd /var/www
#                 7za x .docker/symfonyFiles/compress/symfony.7z

#             fi

#         else
#             if [ -n "$VERVOSE" ]
#             then
#                 echo "No get project name"
#             fi
#         fi

#     fi
# fi











# if [ -n "$COMPRESS" ]
# then
    
#     if [ -n "$VERVOSE" ]
#     then
#         echo "descompress project: $PROJECTNAME"
#     fi

# fi