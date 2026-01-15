# VSCode ROS2 워크스페이스 템플릿

이 템플릿은 VSCode를 IDE로 사용하여 ROS2 개발 환경을 설정하는 데 도움을 줍니다.

이 워크스페이스의 자세한 사용 방법은 [VSCode와 ROS2로 개발하는 방법](https://www.allisonthackston.com/articles/vscode_docker_ros2.html)을 참조하세요.

## 기능

### 코드 스타일

ROS2 공식 포맷터가 IDE에 포함되어 있습니다.

* **C++** uncrustify; `ament_uncrustify` 설정 사용
* **Python** autopep8; [스타일 가이드](https://docs.ros.org/en/humble/The-ROS2-Project/Contributing/Code-Style-Language-Versions.html)와 일관된 VSCode 설정

### 태스크

다양한 사전 정의된 태스크가 있습니다. 전체 목록은 [`.vscode/tasks.json`](.vscode/tasks.json)을 참조하세요. 필요에 따라 자유롭게 수정하세요.

태스크를 활용한 개발 방법에 대한 아이디어는 [태스크를 사용한 개발 방법](https://www.allisonthackston.com/articles/vscode_tasks.html)을 참조하세요.

### 디버깅

이 템플릿은 Python 파일 디버깅, C++ 프로그램용 gdb, ROS launch 파일 디버깅을 설정합니다. 설정 세부 사항은 [`.vscode/launch.json`](.vscode/launch.json)을 참조하세요.

### 지속적 통합 (CI)

이 템플릿에는 기본적인 지속적 통합 설정도 포함되어 있습니다. [`.github/workflows/ros.yaml`](/.github/workflows/ros.yaml)을 참조하세요.

린터를 제거하려면 아래 줄에서 해당 린터의 이름을 삭제하면 됩니다:

```yaml
      matrix:
          linter: [cppcheck, cpplint, uncrustify, lint_cmake, xmllint, flake8, pep257]
```

## 템플릿 사용 방법

### 사전 요구 사항

시스템에 Docker와 원격 컨테이너 플러그인이 설치된 VSCode가 이미 있어야 합니다.

* [Docker](https://docs.docker.com/engine/install/)
* [VSCode](https://code.visualstudio.com/)
* [VSCode 원격 컨테이너 플러그인](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

#### NVidia 지원

Docker에서 NVIDIA 드라이버와 OpenGL을 사용하려면 docker-nvidia 설치 지침을 따르세요.
Docker 설치 단계와 추가 GPU 레이어 설정이 포함되어 있습니다.

* [docker-nvidia (NVIDIA GPU 가속 호스트를 위한 Docker 설치 및 추가 설정)](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)

### 템플릿 가져오기

"use this template" 클릭

![template_use](https://user-images.githubusercontent.com/6098197/91331899-43f23b80-e780-11ea-92c8-b4665ce126f1.png)

### 저장소 생성

다음 대화 상자에서 시작할 저장소 이름을 지정하고 모든 브랜치를 원하는지 기본 브랜치만 원하는지 결정합니다.

> [!IMPORTANT]
>
> 새 기본 브랜치는 `.devcontainer/Dockerfile`의 'FROM' 줄에서 원하는 버전을 설정하여 모든 버전의 ROS를 지원합니다.
>
> 기본값은 `osrf/ros:humble-desktop-full`로 설정되어 있습니다.

![template_new](https://user-images.githubusercontent.com/6098197/91332035-713ee980-e780-11ea-81d3-13b170f568b0.png)

그러면 GitHub가 이 템플릿의 내용으로 새 저장소를 계정에 생성합니다. 최신 변경 사항을 "initial commit"으로 가져옵니다.

### 저장소 클론

이제 평소처럼 저장소를 클론할 수 있습니다.

![template_download](https://user-images.githubusercontent.com/6098197/91332342-e4e0f680-e780-11ea-9525-49b0afa0e4bb.png)

### VSCode에서 열기

컴퓨터에 저장소를 클론했으면 VSCode에서 열 수 있습니다 (파일->폴더 열기).

처음 열면 컨테이너에서 열 것인지 묻는 작은 팝업이 표시됩니다. 예를 선택하세요!

![template_vscode](https://user-images.githubusercontent.com/6098197/91332551-36898100-e781-11ea-9080-729964373719.png)

팝업이 표시되지 않으면 왼쪽 하단의 작은 녹색 사각형을 클릭하면 컨테이너 대화 상자가 나타납니다.

![template_vscode_bottom](https://user-images.githubusercontent.com/6098197/91332638-5d47b780-e781-11ea-9fb6-4d134dbfc464.png)

대화 상자에서 "Remote Containers: Reopen in container"를 선택합니다.

VSCode가 `.devcontainer` 내부의 dockerfile을 빌드합니다. VSCode 내에서 터미널을 열면 (터미널->새 터미널), 사용자 이름이 `ros`로 변경되었고 왼쪽 하단 녹색 모서리에 "Dev Container"라고 표시되는 것을 볼 수 있습니다.

![template_container](https://user-images.githubusercontent.com/6098197/91332895-adbf1500-e781-11ea-8afc-7a22a5340d4a.png)

### 템플릿을 코드로 업데이트

1. `src/ros2.repos`에 워크스페이스에 포함할 저장소를 지정하거나 `src/ros2.repos`를 삭제하고 워크스페이스 내에서 직접 개발합니다.
2. `ros2.repos` 파일을 사용하는 경우 `터미널->태스크 실행..->import from workspace file`로 내용을 가져옵니다.
3. 의존성 설치 `터미널->태스크 실행..->install dependencies`
4. (선택 사항) 스크립트를 원하는 대로 조정합니다. 이 스크립트는 태스크와 CI 모두에서 사용됩니다.
   * `setup.sh` 코드 설정 명령어. 기본값은 워크스페이스 가져오기 및 의존성 설치.
   * `build.sh` 코드 빌드 명령어. 기본값은 `--merge-install` 및 `--symlink-install`
   * `test.sh` 코드 테스트 명령어.
5. 개발 시작!

## FAQ

### XAuthority

다음과 같은 오류가 표시되는 경우:

```text
Authorization required, but no authorization protocol specified Unable to open display: :0 Authorization required, but no authorization protocol specified
```

UID/GID를 본인의 것과 일치하도록 업데이트해야 할 수 있습니다. `.devcontainer/devcontainer.json`에서 `Change to match your UID` 및 `Change to match your GID`로 표시된 줄을 업데이트하세요.

.devcontainer/devcontainer.json

```jsonc
 "build": {
  "args": {
   ...
   // "USERNAME": "ros",
   // "USER_UID": "1000", //Change to match your UID
   // "USER_GID": "1000" // Change to match your GID
  },
 },
 ...
 "runArgs": [
  ...
  "--volume=/run/user/1000:/run/user/1000", // Change 1000 to match your UID
  ...
 ],
```

### XDisplay

다음과 같은 오류가 표시되는 경우:

```text
Couldn't open X display in GLXGLSupport::getGLDisplay at ./.obj-x86_64-linux-gnu/ogre_vendor-prefix/src/ogre_vendor/RenderSystems/GLSupport/src/GLX/OgreGLXGLSupport.cpp
```

Wayland 옵션을 제거하거나 주석 처리해야 합니다.

```jsonc
 "runArgs": [
  ...
  // Wayland 호스트
  //"--volume=/mnt/wslg:/mnt/wslg",
  // "--volume=/run/user/1000:/run/user/1000",
  // Intel 내장 그래픽을 사용하려면 주석 해제
  // "--device=/dev/dri"
  ...
 ],
 ...
  "containerEnv": {
  ...
  // Wayland용
  // "WAYLAND_DISPLAY": "${localEnv:WAYLAND_DISPLAY}",
  // "XDG_RUNTIME_DIR": "${localEnv:XDG_RUNTIME_DIR}",
  // "QT_QPA_PLATFORM": "wayland", // Wayland 강제
  ...
 },
```

### WSL2

#### GUI가 표시되지 않음

DISPLAY 환경 변수가 제대로 설정되지 않았기 때문일 수 있습니다.

1. DISPLAY 변수가 무엇이어야 하는지 확인

      WSL2 Ubuntu 인스턴스에서

      ```bash
      echo $DISPLAY
      ```

2. 해당 값을 `.devcontainer/devcontainer.json` 파일에 복사

      ```jsonc
      "containerEnv": {
        "DISPLAY": ":0",
      }
      ```

#### vGPU 사용하기

WSL2를 통해 vGPU에 액세스하려면 [이 지침](https://github.com/microsoft/wslg/blob/main/samples/container/Containers.md)에 따라 `.devcontainer/devcontainer.json` 파일에 추가 구성 요소를 추가해야 합니다.

```jsonc
 "runArgs": [
  "--network=host",
  "--cap-add=SYS_PTRACE",
  "--security-opt=seccomp:unconfined",
  "--security-opt=apparmor:unconfined",
  "--volume=/tmp/.X11-unix:/tmp/.X11-unix",
  "--volume=/mnt/wslg:/mnt/wslg",
  "--volume=/usr/lib/wsl:/usr/lib/wsl",
  "--device=/dev/dxg",
  "--gpus=all"
 ],
 "containerEnv": {
  "DISPLAY": "${localEnv:DISPLAY}", // GUI에 필요, Windows에서는 ":0" 시도
  "WAYLAND_DISPLAY": "${localEnv:WAYLAND_DISPLAY}",
  "XDG_RUNTIME_DIR": "${localEnv:XDG_RUNTIME_DIR}",
  "PULSE_SERVER": "${localEnv:PULSE_SERVER}",
  "LD_LIBRARY_PATH": "/usr/lib/wsl/lib",
  "LIBGL_ALWAYS_SOFTWARE": "1" // OpenGL 소프트웨어 렌더링에 필요
 },
```

### 저장소가 VS Code 소스 제어에 표시되지 않음

VSCode가 직접 추가하지 않은 다른 저장소를 인식하지 못하기 때문일 수 있습니다.

```text
파일->워크스페이스에 폴더 추가
```

![Screenshot-26](https://github.com/athackst/vscode_ros2_workspace/assets/6098197/d8711320-2c16-463b-9d67-5bd9314acc7f)

또는 git 서브모듈로 추가한 경우입니다.

![Screenshot-27](https://github.com/athackst/vscode_ros2_workspace/assets/6098197/8ebc9aac-9d70-4b53-aa52-9b5b108dc935)

*.repos 파일의 모든 저장소를 추가하려면 스크립트를 실행하세요.

```bash
python3 .devcontainer/repos_to_submodules.py
```

또는 `add submodules from .repos` 태스크를 실행합니다.

### GPU 가속 오류 처리

#### Docker 이미지를 빌드할 수 없음:

Dockerfile은 빌드할 수 있지만 devcontainer.json을 사용하면 "docker container cannot connect to device [[gpu]]"와 같은 오류 메시지가 표시되는 경우 Docker 자체는 설치되었지만 위에서 언급한 nvidia 부분이 설치되지 않은 것입니다.

해결 방법은 가이드를 따르고 여기에 표시된 대로 nvidia-smi로 테스트하는 것입니다:

- [docker-nvidia (Nvidia GPU 호스트에서 GPU 가속용)](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)

#### Docker의 프로그램이 GPU에 액세스할 수 없음

GPU 가속 부족을 나타내는 오류 메시지 (Docker 터미널에서)

```bash
sudo apt-get update   && sudo apt-get install -y -qq glmark2   && glmark2
```

결과:

```bash
   libGL error: No matching fbConfigs or visuals found
   libGL error: failed to load driver: swrast
      X Error of failed request:  GLXBadContext
   Major opcode of failed request:  151 (GLX)
   Minor opcode of failed request:  6 (X_GLXIsDirect)
   Serial number of failed request:  48
   Current serial number in output stream:  47
```

해결 방법은 가이드를 따르고 여기에 표시된 대로 nvidia-smi로 테스트하는 것입니다:
[docker-nvidia (Nvidia GPU 호스트에서 GPU 가속용)](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)

#### 추가 정보

https://wiki.ros.org/docker/Tutorials/GUI
https://medium.com/@benjamin.botto/opengl-and-cuda-applications-in-docker-af0eece000f1
https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker
