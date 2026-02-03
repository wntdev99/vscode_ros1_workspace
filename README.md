# WATT 사용법
1. docker 설치(이미 설치되어있다면 4번으로)
   [공식 설치 링크](https://docs.docker.com/engine/install/)
2. docker desktop 설치 (option)
      [공식 설치 링크](https://docs.docker.com/desktop/setup/install/linux/)

3. ```docker ps``` 로 설치 확인
   만약 권한 문제 발생시 docker 권한 부여
   ```sudo usermod -aG docker {HOSTNAME}```
   ex) ```sudo usermod -aG docker injae```

4. git clone (workspace scale)
```git clone https://github.com/wntdev99/vscode_ros1_workspace.git```
5. vscode로 열기
6. ctrl + shift + p 눌러 rebuild and reopen in container 옵션 선택
      <img width="598" height="101" alt="image" src="https://github.com/user-attachments/assets/09bcda70-9b7c-4658-a231-1f669a14292a" />
7. 완료

# VSCode ROS1 워크스페이스 템플릿

이 템플릿은 VSCode를 IDE로 사용하여 ROS1 Noetic 개발 환경을 설정하는 데 도움을 줍니다.

## 기능

### 코드 스타일

* **C++** uncrustify 또는 cpplint
* **Python** autopep8 및 flake8

### 태스크

다양한 사전 정의된 태스크가 있습니다. 전체 목록은 [`.vscode/tasks.json`](.vscode/tasks.json)을 참조하세요. 필요에 따라 자유롭게 수정하세요.

### 디버깅

이 템플릿은 Python 파일 디버깅, C++ 프로그램용 gdb, ROS launch 파일 디버깅을 설정합니다. 설정 세부 사항은 [`.vscode/launch.json`](.vscode/launch.json)을 참조하세요.

### 지속적 통합 (CI)

이 템플릿에는 기본적인 지속적 통합 설정도 포함되어 있습니다. [`.github/workflows/ros.yaml`](/.github/workflows/ros.yaml)을 참조하세요.

린터를 제거하려면 아래 줄에서 해당 린터의 이름을 삭제하면 됩니다:

```yaml
      matrix:
          linter: [cppcheck, cpplint, flake8]
```

## 템플릿 사용 방법

### 사전 요구 사항

시스템에 Docker와 원격 컨테이너 플러그인이 설치된 VSCode가 이미 있어야 합니다.

* [Docker](https://docs.docker.com/engine/install/)
* [VSCode](https://code.visualstudio.com/)
* [VSCode 원격 컨테이너 플러그인](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### 템플릿을 코드로 업데이트

1. `ros1.repos`에 워크스페이스에 포함할 저장소를 지정합니다.
2. `ros1.repos` 파일을 사용하는 경우 `터미널->태스크 실행..->import from workspace file`로 내용을 가져옵니다.
3. 의존성 설치 `터미널->태스크 실행..->install dependencies`
4. (선택 사항) 스크립트를 원하는 대로 조정합니다. 이 스크립트는 태스크와 CI 모두에서 사용됩니다.
   * `setup.sh` 코드 설정 명령어. 기본값은 워크스페이스 가져오기 및 의존성 설치.
   * `build.sh` 코드 빌드 명령어. catkin build 사용
   * `test.sh` 코드 테스트 명령어.
5. 개발 시작!

## Shell Aliases (컨테이너 내부)

| 명령어 | 동작 |
|--------|------|
| `cm` | 빌드 + 자동 소싱 |
| `cb` | 빌드만 |
| `cw` | 워크스페이스 루트로 이동 |
| `cs` | src/ 폴더로 이동 |
| `eb` | bashrc 편집 |
| `sb` | bashrc 다시 소싱 |

## FAQ

### XAuthority

다음과 같은 오류가 표시되는 경우:

```text
Authorization required, but no authorization protocol specified Unable to open display: :0 Authorization required, but no authorization protocol specified
```

UID/GID를 본인의 것과 일치하도록 업데이트해야 할 수 있습니다. `.devcontainer/devcontainer.json`에서 `Change to match your UID` 및 `Change to match your GID`로 표시된 줄을 업데이트하세요.

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

### GPU 지원

#### Intel 내장 그래픽 (기본)

현재 설정은 Intel 내장 그래픽을 사용합니다 (`--device=/dev/dri`).

#### NVIDIA GPU

NVIDIA GPU를 사용하려면 `.devcontainer/devcontainer.json` 및 `.devcontainer/Dockerfile`의 주석 처리된 섹션을 참조하세요.

* [docker-nvidia 설치 가이드](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)

### 추가 정보

* https://wiki.ros.org/docker/Tutorials/GUI
* https://medium.com/@benjamin.botto/opengl-and-cuda-applications-in-docker-af0eece000f1
