#!/bin/bash

install_aws_cli_ubuntu() {
    sudo apt update
    sudo apt install -y awscli
    echo "AWS CLI успешно установлен для Ubuntu/Debian"
}

install_aws_cli_centos() {
    sudo yum install -y unzip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscli-exe-linux-x86_64.zip"
    unzip awscli-exe-linux-x86_64.zip

    sudo ./aws/install
    
    rm -rf awscli-exe-linux-x86_64.zip aws/
    echo "AWS CLI успешно установлен для CentOS/RHEL"
}


install_aws_cli_macos() {
    if ! command -v brew &> /dev/null; then
        echo "brew не установлен"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        if ! command -v brew &> /dev/null; then
            echo "Не удалось установить Homebrew. Пожалуйста, установите его вручную с https://brew.sh"
            exit 1
        fi
        echo "Homebrew успешно установлен"
    fi
    brew install awscli
    echo "AWS CLI успешно установлен для macOS"
}

install_aws_cli_windows() {
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI не установлен. Устанавливаю AWS CLI"

        Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2/latest/AWSCLIV2.msi" -OutFile "$env:TEMP\AWSCLIV2.msi"

        Start-Process msiexec.exe -ArgumentList "/i", "$env:TEMP\AWSCLIV2.msi", "/quiet", "/norestart" -NoNewWindow -Wait

        if command -v aws &> /dev/null; then
            echo "AWS CLI успешно установлен на Windows"
        else
            echo "Не удалось установить AWS CLI"
            exit 1
        fi
    else
        echo "AWS CLI уже установлен"
    fi
}

configure_aws_cli() {
    aws configure set aws_access_key_id "" --profile "Pert"
    aws configure set aws_secret_access_key "/kkT5UCUfWqVEW0" --profile "Pert"
    aws configure set region "us-east-1" --profile "Pert"
    echo "Профиль успешно настроен"
}

os_type=$(uname -s)

if [[ "$os_type" == "Linux" ]]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                install_aws_cli_ubuntu
                ;;
            centos|rhel)
                install_aws_cli_centos
                ;;
            *)
                echo "Не удалось определить ОС"
                exit 1
                ;;
        esac
    else
        echo "Не удалось определить ОС"
        exit 1
    fi
elif [[ "$os_type" == "Darwin" ]]; then
    install_aws_cli_macos
elif [[ "$os_type" =~ MINGW.* || "$os_type" == "CYGWIN"* ]]; then
    install_aws_cli_windows
else
    echo "Не удалось определить ОС"
    exit 1
fi

if command -v aws &> /dev/null; then
    configure_aws_cli
else
    echo "AWS CLI не установлен"
    exit 1
fi
