FROM public.ecr.aws/amazonlinux/amazonlinux:2 AS awc_cli_installer
RUN yum update -y \
  && yum install -y unzip wget \
  && wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
  && unzip awscli-exe-linux-x86_64.zip \
  # The --bin-dir is specified so that we can copy the
  # entire bin directory from the installer stage into
  # into /usr/local/bin of the final stage without
  # accidentally copying over any other executables that
  # may be present in /usr/local/bin of the installer stage.
  && ./aws/install --bin-dir /aws-cli-bin/

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

RUN apt install -y neovim less groff

RUN apt install -y curl wget dnsutils iputils-tracepath iputils-ping iproute2

RUN apt install -y rsync

RUN apt install -y socat

RUN apt install -y unzip

RUN apt install -y dotnet-sdk-8.0

RUN apt install -y python3 python3-pip
RUN pip3 install --upgrade pip \
  && pip3 install git-filter-repo

RUN apt purge -y software-properties-common rcm
RUN apt autoremove -y
RUN rm -rf /var/lib/apt/lists/*

COPY --from=awc_cli_installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=awc_cli_installer /aws-cli-bin/ /usr/local/bin/

ENTRYPOINT [ "/usr/bin/fish" ]
