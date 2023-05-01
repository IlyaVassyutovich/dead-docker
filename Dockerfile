FROM ubuntu:22.04

RUN apt update \
    && apt upgrade -y

RUN apt install -y software-properties-common

RUN apt install -y rcm

RUN add-apt-repository ppa:fish-shell/release-3
RUN apt install -y fish
RUN usermod --shell /usr/bin/fish root

RUN apt install -y git

WORKDIR /root
RUN git clone "https://github.com/IlyaVassyutovich/myrcs.git"
RUN ln --symbolic ./myrcs/dotfiles ./.dotfiles
RUN rcup -f

ENTRYPOINT [ "/usr/bin/fish" ]
