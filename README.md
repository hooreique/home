개인용 크로스플랫폼 (Linux and macOS) home-manager 구성

WSL (Ubuntu-24.04), macOS Sequoia 15.4.1 에 대해 정상 작동을 확인했다.

## Prerequisites

### 사용자 기초 구성

song 이라는 사용자를 만들고 기본 셸을 Zsh 로 하자.

apt 등 시스템의 기본 패키지 매니저를 이용해서라도 Zsh 를 받자.

**Q.** 왜 셸을 따로 설치하는가. home-manager 구성에 셸도 포함할 수 있지 않은가.
**A.** `/usr/bin/zsh` 와 같이 셸에 직접 접근하는 것을 쉽게 하기 위함이다.

### curl, xz, git

만일 시스템에서 curl 과 xz 명령을 사용할 수 없다면
Nix 설치가 제대로 진행되지 않는다.
다음과 같이 해당 명령이 사용 가능한지 체크해보자.

```bash
which curl
which xz
```

이 구성은 버전 컨트롤 하에 작업했기 때문에
최초 클론부터 git 으로 하는 것이 바람직하다.
(flake 동작에 영향이 있음)
(사실 확인 필요)

```bash
which git
```

## Getting Started

### Nix 설치

https://nixos.org/download/

Linux 에서는 단일 사용자용으로, macOS 에서는 다중 사용자용으로 Nix 를 설치한다.

두 시스템 모두에서 동일하게 단일 사용자용으로 설치하고 싶었으나
macOS 에서는 다중 사용자용 밖에 지원하지 않아 부득이 Nix 설치 구성이 일관되지 않게 되었다.

**Q.** 왜 단일 사용자용을 선호하는가.
**A.** 제거가 간단함

> [!TIP]
> 실제로 Nix 를 제거할 일은 드물다. 하지만 간단히 제거할 수 있다는 사실이
> 나에게는 Nix 도입을 망설이지 않게 하는 중요한 역할을 했다.
> 쓰다가 마음에 안 들면 (혹은 어떤 이유에서든) 지우면 그만이다.

> [!NOTE]
> Nix 는 공식적으로 다중 사용자용 설치를 권장하고 있다.
> https://nix.dev/manual/nix/2.24/installation/multi-user
> 보안 관점에서 합리적이다.

### Nix 기초 구성

채널이 구성되어 있지 않다면 nix 명령어 실행시 관련된 경고가 뜰 수 있다.

```bash
nix-channel --list
```

위 명령을 입력했을 때 다음과 같은 출력이 나타나지 않는다면,

> `nixpkgs https://nixos.org/channels/nixpkgs-unstable`

다음과 같이 채널을 추가하자.

```bash
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update
```

flake 를 사용할 수 있도록 구성하자.

```bash
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf
```

### Bootstrap

home-manager 구성을 클론한다.

```bash
mkdir -p ~/.config/home-manager
git clone https://github.com/hooreique/home.git ~/.config/home-manager
```

home-manager 최초 구성을 위해 다음을 실행한다.

```bash
nix run nixpkgs#home-manager -- switch
```

잘 구성되었다면 이제부터는 home-manager 명령을 직접 사용할 수 있으니 다음과 같이 사용하자.

```bash
home-manager switch
```

## Misc

home-manager 구성은 당연하게도 처음부터 끝까지 지극히 개인적인 내용을 한다.

그 중 몇 개만 소개하자면...

- ssh 통신용 키로 `~/.ssh/id_ed25519` 를 사용한다. (따로 준비해야 한다.)
  - 그리고 그것을 git commit signing 에도 사용한다.
- git 통신 프로토콜로 ssh 를 사용한다.
- 선택적인 `~/init.zsh` 의 사용을 고려하고 있다.
  - 어떤 이유에서든 특정 환경에서만 유의미한 구성이 있게 마련이다.
- sshd 용 키를 따로 만들어서 쓰고 있다.
  - sshd 를 데몬으로 쓰지 않고 필요할 때마다 직접 실행하는데 이때 필요한 옵션 (호스트 키 포함) 을 커맨드라인 옵션으로 매번 지정한다.
- `hoobira.zsh-theme` 은 직접 만든 Zsh Theme 이다.
  - 그 내용을 보면 알 수 있듯이 `bira` 를 기반으로 만들었다.

### WSL Stuff

다음은 WSL Ubuntu-24.04 인스턴스 내의 `/etc/wsl.conf` 파일의 내용이다.

```ini
# https://learn.microsoft.com/en-us/windows/wsl/wsl-config#systemd-support
[boot]
systemd=true

# https://learn.microsoft.com/en-us/windows/wsl/wsl-config#interop-settings
[interop]
appendWindowsPath=false
```

호스트 (Windows) 에 의해 `PATH` 환경 변수가 오염되는 것을 방지하고자
`interop.appendWindowsPath` 속성을 `false` 로 지정했다.

`boot.systemd` 부분은 기본값이다. (주석만 추가로 달았다.)

> [!TIP]
> 참고할 만한 `/etc/wsl.conf` 의 예시
> https://learn.microsoft.com/en-us/windows/wsl/wsl-config#example-wslconf-file

### macOS Stuff

`/etc/zprofile` 을 보면

> `eval $(/usr/libexec/path_helper -s)`

이런 부분이 있는데 실행해보면 알겠지만
어떤 이유에서인지 macOS 는 기본적으로 `PATH` 환경 변수를 쉘 로그인시 세팅하고 있다.

Linux 환경과의 유사성을 극대화 하고자 이 부분을 주석처리하여 `PATH` 를 깔끔하게 유지했다.
보안에는 스스로 좀 더 신경 써야 할 것이다.
macOS 를 업데이트하면 `/etc/zprofile` 이 복원된다.
때문에 `zshrc` 의 내용처럼 `/etc/zprofile` 에 유효한 내용이 있다면 알려주는 식으로 구성했다.
