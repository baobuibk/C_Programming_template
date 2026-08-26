# Setup VS Code cho lập trình C trên Windows

Hướng dẫn đầy đủ từ máy trắng đến debug được chương trình C. Làm tuần tự từ trên xuống, mỗi bước đều có cách kiểm tra kết quả trước khi sang bước tiếp theo.

**Thời gian dự kiến:** 20–30 phút (phần lớn là chờ tải gói).

---

## Mục lục

1. [Cần cài những gì](#1-cần-cài-những-gì)
2. [Cài VS Code](#2-cài-vs-code)
3. [Cài compiler bằng MSYS2](#3-cài-compiler-bằng-msys2)
4. [Thêm vào PATH](#4-thêm-vào-path)
5. [Kiểm tra compiler](#5-kiểm-tra-compiler--bắt-buộc)
6. [Cài extension](#6-cài-extension)
7. [Tạo project đầu tiên](#7-tạo-project-đầu-tiên)
8. [Ba file cấu hình](#8-ba-file-cấu-hình)
9. [Build và Debug](#9-build-và-debug)
10. [Chạy nhanh với Code Runner](#10-chạy-nhanh-với-code-runner)
11. [Sửa lỗi font tiếng Việt](#11-sửa-lỗi-font-tiếng-việt)
12. [Project nhiều file: Makefile](#12-project-nhiều-file)
    - [12.1. Kiểm soát danh sách file được biên dịch](#121-kiểm-soát-danh-sách-file-được-biên-dịch)
    - [12.2. Lỗi `no input files`](#122-lỗi-gcc-fatal-error-no-input-files)
13. [Format code](#13-format-code)
14. [Phím tắt](#14-phím-tắt)
15. [Xử lý lỗi thường gặp](#15-xử-lý-lỗi-thường-gặp)
16. [Checklist](#16-checklist)

---

## 1. Cần cài những gì

VS Code chỉ là trình soạn thảo, không phải IDE. Bạn cần 3 thứ:

| Thành phần | Công cụ | Vai trò |
|---|---|---|
| Editor | VS Code | Gõ code |
| Compiler + Debugger | MSYS2 (chứa GCC + GDB) | Biên dịch, chạy từng dòng |
| Extension | C/C++ của Microsoft | Nối editor với compiler |

> **Vì sao chọn MSYS2 thay vì các bản MinGW lẻ?** MSYS2 có trình quản lý gói `pacman`, cập nhật dễ, đủ cả `gcc`, `gdb`, `make`, `clang-format` trong một lần cài, và không bị lỗi thiếu DLL như các bản MinGW cũ tải rời.

---

## 2. Cài VS Code

Tải bản Windows tại <https://code.visualstudio.com/download> (chọn **User Installer x64**).

Khi chạy trình cài đặt, ở màn hình **Select Additional Tasks** hãy tick:

- ✅ Add "Open with Code" action to Windows Explorer **file** context menu
- ✅ Add "Open with Code" action to Windows Explorer **directory** context menu
- ✅ Register Code as an editor for supported file types
- ✅ **Add to PATH** (quan trọng — cho phép gõ `code .` trong terminal)

---

## 3. Cài compiler bằng MSYS2

**Bước 3.1.** Tải bộ cài tại <https://www.msys2.org/> (file dạng `msys2-x86_64-xxxxxxxx.exe`). Chạy và **giữ nguyên đường dẫn mặc định `C:\msys64`** — các bước sau sẽ dùng đúng đường dẫn này.

**Bước 3.2.** Sau khi cài xong, mở Start Menu → gõ `MSYS2` → chọn **MSYS2 UCRT64**.

> ⚠️ Có nhiều cửa sổ MSYS2 (MSYS, MINGW64, UCRT64, CLANG64). Phải chọn đúng **UCRT64**. Biểu tượng có chữ màu xanh dương, dòng nhắc lệnh hiện `UCRT64`.

**Bước 3.3.** Cập nhật hệ thống gói:

```bash
pacman -Syu
```

Gõ `Y` khi được hỏi. Cửa sổ có thể **tự đóng đột ngột** — đây là hành vi bình thường. Mở lại **MSYS2 UCRT64** và chạy tiếp:

```bash
pacman -Su
```

**Bước 3.4.** Cài bộ công cụ biên dịch:

```bash
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
```

Khi hiện danh sách gói và hỏi `Enter a selection (default=all)`, chỉ cần **nhấn Enter** để chọn tất cả, rồi gõ `Y` xác nhận. Quá trình tải khoảng 1–2 GB, mất vài phút.

Bộ này đã bao gồm: `gcc`, `g++`, `gdb`, `make`, `clang-format`, và các thư viện chuẩn.

**Bước 3.5.** Đóng cửa sổ MSYS2. Từ giờ bạn không cần mở nó nữa (trừ khi muốn cài thêm thư viện).

---

## 4. Thêm vào PATH

Nếu bỏ qua bước này, VS Code sẽ báo `'gcc' is not recognized`.

1. Nhấn phím **Windows** → gõ `environment` → chọn **Edit the system environment variables**
2. Trong cửa sổ System Properties, bấm nút **Environment Variables…**
3. Ở khung trên (**User variables for [tên bạn]**), chọn dòng **Path** → bấm **Edit…**
4. Bấm **New** → dán vào:

```
C:\msys64\ucrt64\bin
```

5. Nếu bạn cũng muốn dùng `make` từ Command Prompt, thêm một dòng nữa:

```
C:\msys64\usr\bin
```

6. Bấm **OK** ở cả ba cửa sổ để lưu

**Quan trọng:** đóng **toàn bộ** cửa sổ Terminal, Command Prompt, PowerShell và VS Code đang mở, rồi mở lại. Windows chỉ nạp PATH mới cho tiến trình khởi động sau khi thay đổi.

---

## 5. Kiểm tra compiler — bắt buộc

Mở **Command Prompt mới** (Windows + R → gõ `cmd` → Enter) và chạy lần lượt:

```cmd
gcc --version
gdb --version
mingw32-make --version
```

Kết quả mong đợi — mỗi lệnh in ra thông tin phiên bản, ví dụ:

```
gcc.exe (Rev3, Built by MSYS2 project) 14.2.0
```

Nếu bất kỳ lệnh nào báo `'gcc' is not recognized as an internal or external command` → PATH chưa đúng. Kiểm tra:
- Thư mục `C:\msys64\ucrt64\bin` có tồn tại và có file `gcc.exe` không?
- Bạn đã mở Command Prompt **mới** sau khi sửa PATH chưa?

**Không sang bước 6 khi bước này chưa chạy được.** Mọi lỗi về sau đều bắt nguồn từ đây.

---

## 6. Cài extension

Mở VS Code → nhấn `Ctrl+Shift+X`.

**Bắt buộc:**

| Tên | Publisher |
|---|---|
| **C/C++** | Microsoft |

Gõ `C/C++` vào ô tìm kiếm, chọn extension có publisher là **Microsoft** (biểu tượng chữ C++ xanh dương), bấm **Install**.

**Nên cài thêm:**

| Tên | Tác dụng |
|---|---|
| **Code Runner** (Jun Han) | Chạy file bằng một phím bấm |
| **Error Lens** (Alexander) | Hiện lỗi ngay trên dòng code, không phải rê chuột |
| **Better C++ Syntax** | Tô màu cú pháp chính xác hơn |

**Tránh:** không cài **clangd** cùng lúc với **C/C++**. Hai extension này xung đột IntelliSense, gây gạch đỏ sai ở khắp nơi.

---

## 7. Tạo project đầu tiên

**Bước 7.1.** Tạo một thư mục, ví dụ `D:\code\hello-c`

> ⚠️ **Đường dẫn tuyệt đối không được có dấu tiếng Việt, khoảng trắng hay ký tự đặc biệt.**
> ❌ `D:\Bài tập\Buổi 1` — sẽ gây lỗi biên dịch rất khó hiểu
> ✅ `D:\code\baitap01`

**Bước 7.2.** Mở VS Code → **File → Open Folder…** → chọn thư mục vừa tạo.

> **Nguyên tắc quan trọng:** luôn mở **thư mục**, đừng bao giờ chỉ mở file `.c` lẻ. Mọi cấu hình build/debug đều gắn với thư mục.

Nếu VS Code hỏi *"Do you trust the authors of the files in this folder?"* → chọn **Yes, I trust the authors**.

**Bước 7.3.** Ở panel Explorer bên trái, bấm biểu tượng **New File**, tạo file `main.c`:

```c
#include <stdio.h>

int main(void) {
    int a, b;

    printf("Nhap hai so nguyen: ");
    scanf("%d %d", &a, &b);

    int tong = a + b;
    printf("%d + %d = %d\n", a, b, tong);

    return 0;
}
```

**Bước 7.4.** Kiểm tra nhanh. Nhấn `` Ctrl+` `` để mở terminal tích hợp, chạy:

```cmd
gcc main.c -o main.exe
.\main.exe
```

Nếu chương trình chạy và nhận được số bạn nhập → compiler và VS Code đã kết nối được. Giờ ta cấu hình để tự động hóa.

---

## 8. Ba file cấu hình

Tạo thư mục `.vscode` trong project (bấm New Folder ở Explorer, đặt tên đúng là `.vscode` có dấu chấm đầu). Bên trong tạo 3 file sau.

### 8.1. `.vscode/c_cpp_properties.json` — IntelliSense

Lo phần gợi ý code, nhảy tới định nghĩa hàm, báo lỗi khi đang gõ.

```json
{
    "configurations": [
        {
            "name": "Win32",
            "includePath": [
                "${workspaceFolder}/**"
            ],
            "defines": [
                "_DEBUG",
                "UNICODE",
                "_UNICODE"
            ],
            "compilerPath": "C:/msys64/ucrt64/bin/gcc.exe",
            "cStandard": "c17",
            "cppStandard": "c++17",
            "intelliSenseMode": "windows-gcc-x64"
        }
    ],
    "version": 4
}
```

> Trong JSON, đường dẫn Windows dùng dấu `/` hoặc `\\`, **không** dùng `\` đơn.

### 8.2. `.vscode/tasks.json` — lệnh build

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "type": "shell",
            "label": "build active file",
            "command": "C:/msys64/ucrt64/bin/gcc.exe",
            "args": [
                "-g",
                "-Wall",
                "-Wextra",
                "-std=c17",
                "${file}",
                "-o",
                "${fileDirname}\\${fileBasenameNoExtension}.exe"
            ],
            "options": {
                "cwd": "${fileDirname}"
            },
            "problemMatcher": ["$gcc"],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "detail": "Bien dich file dang mo"
        },
        {
            "type": "shell",
            "label": "build all c files",
            "command": "C:/msys64/ucrt64/bin/gcc.exe",
            "args": [
                "-g",
                "-Wall",
                "-Wextra",
                "-std=c17",
                "${workspaceFolder}\\*.c",
                "-o",
                "${workspaceFolder}\\program.exe"
            ],
            "options": {
                "cwd": "${workspaceFolder}"
            },
            "problemMatcher": ["$gcc"],
            "group": "build",
            "detail": "Bien dich toan bo file .c trong thu muc goc"
        }
    ]
}
```

**Ý nghĩa các cờ biên dịch:**

| Cờ | Tác dụng |
|---|---|
| `-g` | Nhúng thông tin debug — **bắt buộc** nếu muốn đặt breakpoint |
| `-Wall` | Bật cảnh báo thông dụng |
| `-Wextra` | Bật thêm cảnh báo (biến không dùng, so sánh có/không dấu…) |
| `-std=c17` | Dùng chuẩn C17, có thể đổi thành `c99` hoặc `c11` |
| `-lm` | Cần khi dùng `sqrt`, `pow`… — đặt ở **cuối** mảng `args` |
| `-O2` | Tối ưu tốc độ, chỉ dùng khi phát hành, không dùng chung với `-g` |

**Biến của VS Code:**

| Biến | Nghĩa |
|---|---|
| `${file}` | Đường dẫn đầy đủ file đang mở |
| `${fileBasenameNoExtension}` | Tên file bỏ đuôi `.c` |
| `${fileDirname}` | Thư mục chứa file đang mở |
| `${workspaceFolder}` | Thư mục gốc project |

### 8.3. `.vscode/launch.json` — debug

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug C (gdb)",
            "type": "cppdbg",
            "request": "launch",
            "program": "${fileDirname}\\${fileBasenameNoExtension}.exe",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${fileDirname}",
            "environment": [],
            "externalConsole": true,
            "MIMode": "gdb",
            "miDebuggerPath": "C:/msys64/ucrt64/bin/gdb.exe",
            "setupCommands": [
                {
                    "description": "Bat in dep cho gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "build active file"
        }
    ]
}
```

**Lưu ý về `externalConsole`:**
- `true` → mở cửa sổ Console riêng, `scanf` nhập được bình thường (khuyến nghị khi chương trình có nhập liệu)
- `false` → chạy trong terminal tích hợp, gọn hơn nhưng nhập liệu đôi khi trục trặc

**`preLaunchTask`** phải trùng khớp chính xác với `label` trong `tasks.json`, nếu không VS Code sẽ báo lỗi không tìm thấy task.

---

## 9. Build và Debug

### Build

Nhấn `Ctrl+Shift+B`. Terminal hiện kết quả biên dịch. Nếu có lỗi, chúng xuất hiện trong tab **PROBLEMS** — bấm vào là nhảy tới đúng dòng.

### Debug từng dòng

Đây là lý do đáng giá nhất để dùng VS Code.

1. Bấm vào **lề trái** ngay cạnh số dòng → xuất hiện chấm đỏ (**breakpoint**)
2. Nhấn `F5`
3. Chương trình chạy rồi dừng lại tại breakpoint
4. Panel bên trái hiện mục **VARIABLES** — giá trị mọi biến tại thời điểm đó

**Phím điều khiển khi đang debug:**

| Phím | Hành động |
|---|---|
| `F5` | Chạy tiếp tới breakpoint kế tiếp |
| `F10` | **Step Over** — chạy hết dòng hiện tại, không chui vào hàm |
| `F11` | **Step Into** — bước vào bên trong hàm đang được gọi |
| `Shift+F11` | **Step Out** — chạy nốt hàm hiện tại rồi thoát ra ngoài |
| `Shift+F5` | Dừng debug |
| `Ctrl+Shift+F5` | Khởi động lại |

**Mẹo dùng panel WATCH:** bấm dấu `+` để theo dõi biểu thức bất kỳ. Với con trỏ mảng, gõ `*arr@10` để xem 10 phần tử đầu — rất hữu ích khi debug thuật toán sắp xếp.

---

## 10. Chạy nhanh với Code Runner

Khi chỉ muốn chạy thử, không cần debug.

Nhấn `Ctrl+Shift+P` → gõ **Preferences: Open User Settings (JSON)** → thêm vào:

```json
"code-runner.runInTerminal": true,
"code-runner.saveFileBeforeRun": true,
"code-runner.executorMap": {
    "c": "cd $dir && gcc -Wall -Wextra -std=c17 $fileName -o $fileNameWithoutExt.exe && $dir$fileNameWithoutExt.exe"
}
```

> **`runInTerminal` phải là `true`.** Nếu để `false`, code chạy trong Output panel vốn chỉ đọc, và `scanf` sẽ không nhận được bàn phím — lỗi này rất nhiều người mới gặp.

### 10.1. Bốn cách chạy Code Runner

Phím tắt `Ctrl+Alt+N` **rất hay bị phần mềm khác chiếm mất** trên Windows. Dưới đây là các cách chạy khác, luôn hoạt động kể cả khi phím tắt hỏng.

**Cách 1 — Chuột phải (đơn giản nhất, khuyến nghị)**

1. Mở file `.c` cần chạy
2. Bấm **chuột phải** vào bất kỳ đâu trong vùng soạn thảo
3. Chọn **Run Code** trong menu hiện ra

**Cách 2 — Nút Play ở góc phải trên**

Ở góc trên bên phải cửa sổ VS Code có biểu tượng **▷** (hình tam giác). Bấm trực tiếp vào đó để chạy. Nếu bấm vào mũi tên nhỏ **⌄** bên cạnh, bạn sẽ thấy danh sách các cách chạy khác nhau (**Run Code**, **Run C/C++ File**, **Debug C/C++ File**).

> Nếu không thấy nút này, bấm chuột phải lên thanh tiêu đề tab → bật **Editor Actions**.

**Cách 3 — Command Palette**

1. Nhấn `Ctrl+Shift+P`
2. Gõ `Run Code`
3. Nhấn Enter

Cách này luôn dùng được, không phụ thuộc phím tắt hay menu.

**Cách 4 — Menu Terminal → Run Task**

Dùng cho các task build đã cấu hình ở mục 8: **Terminal → Run Build Task…** (tương đương `Ctrl+Shift+B`).

**Dừng chương trình đang chạy:** bấm biểu tượng **thùng rác** 🗑 ở góc phải panel Terminal, hoặc nhấn `Ctrl+C` trong terminal.

### 10.2. Kiểm tra phím tắt có bị chiếm không

`Ctrl+Alt+N` thường bị các phần mềm sau giành mất: NVIDIA GeForce Experience, bộ gõ tiếng Việt (UniKey, EVKey), Zalo, TeamViewer, hoặc một extension VS Code khác.

Cách kiểm tra trong VS Code:

1. Nhấn `Ctrl+K` rồi nhấn tiếp `Ctrl+S` (mở **Keyboard Shortcuts**)
2. Bấm vào biểu tượng **bàn phím** ở góc phải trên ô tìm kiếm (**Record Keys**)
3. Nhấn tổ hợp `Ctrl+Alt+N`

Kết quả cho biết tình trạng:
- **Không hiện gì cả** → phím tắt bị phần mềm **bên ngoài** VS Code chiếm (VS Code không nhận được tín hiệu)
- **Hiện nhiều hơn một dòng** → xung đột giữa các extension trong VS Code
- **Hiện đúng một dòng `Run Code`** → phím tắt bình thường, lỗi nằm ở chỗ khác

### 10.3. Cách đổi phím tắt

**Đổi qua giao diện (dễ nhất):**

1. Nhấn `Ctrl+K` rồi `Ctrl+S` để mở **Keyboard Shortcuts**
2. Gõ `Run Code` vào ô tìm kiếm
3. Tìm dòng có Command là **Run Code**
4. Bấm vào biểu tượng **bút chì** ✏ bên trái dòng đó (hoặc bấm đúp vào dòng)
5. Nhấn tổ hợp phím mới bạn muốn dùng
6. Nhấn **Enter** để lưu

Nếu VS Code cảnh báo phím này đã được dùng cho lệnh khác, bấm vào link cảnh báo để xem lệnh nào đang chiếm, rồi quyết định giữ hay đổi.

**Gợi ý phím thay thế** (ít bị chiếm trên Windows):

| Phím tắt | Ghi chú |
|---|---|
| `F8` | Ngắn gọn, một phím, hiếm khi xung đột |
| `Ctrl+R` | Dễ nhớ (R = Run), nhưng cần gỡ khỏi lệnh *Open Recent* mặc định trước |
| `Ctrl+Alt+R` | An toàn, ít phần mềm dùng |
| `Alt+F5` | Không đụng với `F5` của debug |

**Đổi bằng file cấu hình (nhanh hơn nếu muốn đặt nhiều phím):**

Nhấn `Ctrl+Shift+P` → gõ **Preferences: Open Keyboard Shortcuts (JSON)** → thêm vào mảng:

```json
[
    {
        "key": "f8",
        "command": "code-runner.run",
        "when": "editorTextFocus"
    },
    {
        "key": "shift+f8",
        "command": "code-runner.stop"
    },
    {
        "key": "ctrl+alt+n",
        "command": "-code-runner.run"
    }
]
```

Giải thích:
- Dòng đầu gán `F8` cho lệnh chạy
- Dòng hai gán `Shift+F8` cho lệnh dừng
- Dòng ba có dấu **`-`** đứng trước tên lệnh, nghĩa là **gỡ bỏ** phím tắt cũ. Nên giữ dòng này để tránh hai phím cùng làm một việc.

Lưu file (`Ctrl+S`) là có hiệu lực ngay, không cần khởi động lại.

### 10.4. Nếu nguyên nhân là phần mềm bên ngoài

Trường hợp `Ctrl+Alt+N` bị chiếm bởi phần mềm ngoài, bạn có thể chọn một trong hai hướng: đổi phím tắt trong VS Code như mục 10.3 (đơn giản hơn), hoặc tắt phím tắt ở phần mềm kia.

Với thủ phạm hay gặp nhất là **NVIDIA GeForce Experience**: mở app → **Settings** (bánh răng) → **General** → tắt **In-Game Overlay**. Hoặc vào **Settings → Keyboard shortcuts** để gỡ riêng tổ hợp đó.

Với **UniKey / EVKey**: chuột phải biểu tượng ở khay hệ thống → **Bảng điều khiển** → kiểm tra mục phím tắt chuyển chế độ gõ, đổi sang tổ hợp khác.

---

## 11. Sửa lỗi font tiếng Việt

Nếu `printf("Xin chào");` in ra ký tự lạ như `Xin ch�o`:

**Cách 1 — thêm cờ khi biên dịch** (thêm vào `args` trong `tasks.json`):

```json
"-fexec-charset=UTF-8",
```

**Cách 2 — đổi code page của terminal.** Thêm vào `settings.json`:

```json
"terminal.integrated.defaultProfile.windows": "Command Prompt",
"terminal.integrated.profiles.windows": {
    "Command Prompt": {
        "path": "C:\\Windows\\System32\\cmd.exe",
        "args": ["/K", "chcp 65001>nul"]
    }
}
```

**Cách 3 — trong code C**, thêm vào đầu `main()`:

```c
#include <windows.h>
// ...
int main(void) {
    SetConsoleOutputCP(CP_UTF8);
    // phần còn lại
}
```

> Thực tế, khi làm bài tập nộp thầy cô, cách đơn giản và an toàn nhất là **viết thông báo không dấu** (`"Nhap so:"` thay vì `"Nhập số:"`).

---

## 12. Project nhiều file

Khi có nhiều hơn 2–3 file `.c`, dùng Makefile sẽ gọn hơn nhiều.

Cấu trúc thư mục gợi ý:

```
my-project/
├── .vscode/
├── src/
│   ├── main.c
│   └── stack.c
├── include/
│   └── stack.h
└── Makefile
```

File `Makefile` (⚠️ các dòng lệnh phải thụt đầu bằng **phím Tab**, không phải dấu cách):

```makefile
# ---- Phat hien he dieu hanh ----
ifeq ($(OS),Windows_NT)
    TARGET  = program.exe
    RM      = del /Q
    FIXPATH = $(subst /,\,$1)
    NULLDEV = 2>nul
else
    TARGET  = program
    RM      = rm -f
    FIXPATH = $1
    NULLDEV = 2>/dev/null
endif

# ---- Cau hinh ----
CC     = gcc
CFLAGS = -Wall -Wextra -std=c17 -g -Iinclude
SRC    = $(wildcard *.c) $(wildcard src/*.c)
OBJ    = $(SRC:.c=.o)

# ---- Luat build ----
all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	-$(RM) $(call FIXPATH,$(OBJ)) $(TARGET) $(NULLDEV)

show:
	@echo SRC = $(SRC)
	@echo TARGET = $(TARGET)

.PHONY: all clean show
```

**Vì sao cần phân biệt hệ điều hành:**

| Điểm khác | Windows | Linux / macOS |
|---|---|---|
| Lệnh xóa file | `del /Q` | `rm -f` |
| Dấu ngăn thư mục | `src\main.o` | `src/main.o` |
| Đuôi file thực thi | `.exe` | không có |
| Nơi vứt thông báo lỗi | `2>nul` | `2>/dev/null` |

Biến `OS` được Windows đặt sẵn với giá trị `Windows_NT`; Linux và macOS không có biến này, nên `ifeq` tự chọn đúng nhánh.

> **Bắt buộc đặt `TARGET = program.exe` trên Windows.** MinGW-GCC tự động thêm `.exe` vào file output. Nếu Makefile ghi `TARGET = program`, file thật sinh ra là `program.exe` nhưng `make` lại đi tìm `program` — không thấy, nên **lần nào chạy `make` nó cũng biên dịch lại từ đầu** dù code không hề thay đổi.

**Cách kiểm tra Makefile đúng:** chạy `make` hai lần liên tiếp. Lần thứ hai phải in ra `make: Nothing to be done for 'all'.` Nếu nó build lại thì tên `TARGET` chưa khớp với file thật sinh ra.

Ba chi tiết trong dòng `clean` dễ bị bỏ sót:
- Dấu **`-`** ở đầu dòng bảo `make` bỏ qua lỗi nếu file cần xóa không tồn tại
- **`$(call FIXPATH,...)`** đổi `src/main.o` thành `src\main.o` trên Windows, vì `del` không hiểu dấu `/`
- **`$(NULLDEV)`** giấu thông báo *"Could not find"* khi thư mục đã sạch sẵn

Thêm task gọi make vào `tasks.json`:

```json
{
    "type": "shell",
    "label": "make",
    "command": "mingw32-make",
    "options": { "cwd": "${workspaceFolder}" },
    "problemMatcher": ["$gcc"],
    "group": { "kind": "build", "isDefault": true }
}
```

> Trên MSYS2, lệnh có tên `mingw32-make`. Muốn gõ `make` cho quen tay, tạo file `make.bat` trong `C:\msys64\ucrt64\bin` với nội dung `@mingw32-make %*`.

Khi dùng Makefile, sửa `preLaunchTask` trong `launch.json` thành `"make"` và `program` thành `"${workspaceFolder}\\program.exe"`.

### 12.1. Kiểm soát danh sách file được biên dịch

`$(wildcard src/*.c)` gom **tất cả** file `.c`. Khi cần thêm bớt có chọn lọc, dùng một trong bốn cách sau.

#### Cách A — Liệt kê tay (rõ ràng nhất)

```makefile
SRC = src/main.c \
      src/stack.c \
      src/queue.c
```

Dấu `\` cuối dòng là ký tự nối dòng — **sau nó không được có khoảng trắng nào**, nếu không `make` báo lỗi rất khó hiểu. Dòng cuối cùng không cần `\`.

- **Thêm file:** chèn dòng mới, nhớ thêm `\` vào dòng phía trên
- **Bớt file:** xóa dòng đó; nếu nó là dòng cuối thì bỏ `\` ở dòng ngay trước

Phù hợp với project ổn định: đọc Makefile là biết ngay dự án gồm những file nào.

#### Cách B — Quét hết rồi loại trừ (linh hoạt nhất)

```makefile
ALL_SRC = $(wildcard src/*.c)
EXCLUDE = src/test_main.c src/bai_cu.c
SRC     = $(filter-out $(EXCLUDE), $(ALL_SRC))
```

- **Thêm file:** chỉ cần tạo file mới trong `src/`, tự động được nhận
- **Bớt file:** thêm tên vào `EXCLUDE`, không cần xóa file khỏi ổ đĩa

Rất hợp khi bạn có nhiều file chứa hàm `main()` (mỗi bài tập một file) và chỉ muốn build một cái tại một thời điểm — vì nhiều `main()` cùng lúc sẽ gây lỗi `multiple definition of main`.

#### Cách C — Bật/tắt theo nhóm bằng biến

```makefile
SRC = src/main.c src/core.c

USE_GRAPHICS = 1
USE_NETWORK  = 0

ifeq ($(USE_GRAPHICS),1)
    SRC    += src/graphics.c src/render.c
    CFLAGS += -DUSE_GRAPHICS
endif

ifeq ($(USE_NETWORK),1)
    SRC     += src/network.c
    LDFLAGS += -lws2_32
endif
```

Đổi `1` thành `0` là loại cả nhóm file. Cờ `-DUSE_GRAPHICS` cho phép dùng `#ifdef USE_GRAPHICS` trong code C tương ứng.

Ghi đè ngay lúc chạy mà không cần sửa file:

```cmd
mingw32-make USE_NETWORK=1
```

> Lưu ý: khối `ifeq` / `endif` phải **sát lề trái**, không thụt vào. Ngược lại hoàn toàn với các dòng lệnh biên dịch (phải thụt bằng Tab).

#### Cách D — Nhiều chương trình trong một Makefile

Khi mỗi bài tập là một file thực thi riêng nhưng dùng chung vài file tiện ích:

```makefile
ifeq ($(OS),Windows_NT)
    EXT     = .exe
    RM      = del /Q
    NULLDEV = 2>nul
else
    EXT     =
    RM      = rm -f
    NULLDEV = 2>/dev/null
endif

CC     = gcc
CFLAGS = -Wall -Wextra -std=c17 -g -Iinclude

COMMON   = src/util.c src/list.c
BAI1_SRC = src/bai1.c $(COMMON)
BAI2_SRC = src/bai2.c $(COMMON)

all: bai1$(EXT) bai2$(EXT)

bai1$(EXT): $(BAI1_SRC)
	$(CC) $(CFLAGS) $^ -o $@

bai2$(EXT): $(BAI2_SRC)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	-$(RM) bai1$(EXT) bai2$(EXT) $(NULLDEV)

.PHONY: all clean
```

Chạy `mingw32-make bai1.exe` để build riêng bài 1, hoặc `mingw32-make all` cho tất cả. Trên Linux thì tên target không có đuôi: `make bai1`.

Trong đó `$^` là toàn bộ danh sách phụ thuộc, `$@` là tên target đang build.

#### Kiểm tra danh sách trước khi build

Thêm target này vào Makefile để xem `make` thực sự đang thấy những file nào:

```makefile
show:
	@echo SRC = $(SRC)
```

Chạy `mingw32-make show`. Thói quen này tiết kiệm rất nhiều thời gian mò lỗi.

### 12.2. Lỗi `gcc: fatal error: no input files`

Lỗi này nghĩa là biến `$(SRC)` **rỗng** — `make` không tìm thấy file `.c` nào nên gọi `gcc -o program.exe` mà không có file đầu vào.

**Chẩn đoán:** chạy `mingw32-make -n all`. Lệnh này chỉ *in ra* lệnh sẽ chạy chứ không thực thi, bạn sẽ thấy rõ chỗ thiếu tên file. Hoặc dùng target `show` ở trên.

**Bốn nguyên nhân, theo thứ tự phổ biến:**

| Nguyên nhân | Cách kiểm tra | Cách sửa |
|---|---|---|
| File `.c` nằm ở thư mục gốc, không trong `src/` | `dir /b` | Đổi thành `SRC = $(wildcard *.c) $(wildcard src/*.c)` |
| Chạy `make` từ sai thư mục | Gõ `cd` xem đang ở đâu | `cd` về thư mục chứa `Makefile` |
| Đuôi file thật là `.c.txt` | `dir /b src` | Bật **View → Show → File name extensions** trong Explorer rồi đổi tên |
| Thư mục `src` chưa tồn tại | `dir /b` | Tạo thư mục, hoặc sửa đường dẫn trong `wildcard` |

> Windows mặc định **ẩn phần mở rộng file**. Nếu bạn tạo file bằng Notepad, tên thật rất dễ thành `main.c.txt` và `wildcard` sẽ bỏ qua nó mà không báo gì.

**Makefile có tự kiểm tra**, báo lỗi rõ ràng thay vì để `gcc` kêu khó hiểu:

```makefile
ifeq ($(OS),Windows_NT)
    TARGET  = program.exe
    RM      = del /Q
    FIXPATH = $(subst /,\,$1)
    NULLDEV = 2>nul
else
    TARGET  = program
    RM      = rm -f
    FIXPATH = $1
    NULLDEV = 2>/dev/null
endif

CC     = gcc
CFLAGS = -Wall -Wextra -std=c17 -g -Iinclude
SRC    = $(wildcard *.c) $(wildcard src/*.c)
OBJ    = $(SRC:.c=.o)

all: check $(TARGET)

check:
ifeq ($(strip $(SRC)),)
	$(error Khong tim thay file .c nao. Kiem tra vi tri file va thu muc dang chay make)
endif

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	-$(RM) $(call FIXPATH,$(OBJ)) $(TARGET) $(NULLDEV)

show:
	@echo SRC = $(SRC)
	@echo TARGET = $(TARGET)

.PHONY: all check clean show
```

---

## 13. Format code

Extension C/C++ đã tích hợp sẵn `clang-format`. Thêm vào `settings.json`:

```json
"[c]": {
    "editor.defaultFormatter": "ms-vscode.cpptools",
    "editor.formatOnSave": true,
    "editor.tabSize": 4,
    "editor.insertSpaces": true
},
"C_Cpp.clang_format_fallbackStyle": "{ BasedOnStyle: LLVM, IndentWidth: 4, ColumnLimit: 100 }"
```

Format thủ công: `Shift+Alt+F`

Muốn kiểm soát chi tiết, tạo file `.clang-format` ở thư mục gốc project:

```yaml
BasedOnStyle: LLVM
IndentWidth: 4
UseTab: Never
ColumnLimit: 100
BreakBeforeBraces: Attach
PointerAlignment: Right
AllowShortFunctionsOnASingleLine: None
```

---

## 14. Phím tắt

| Phím tắt | Chức năng |
|---|---|
| `Ctrl+Shift+B` | Build |
| `F5` | Debug |
| `Ctrl+F5` | Chạy không debug |
| `Ctrl+Alt+N` | Code Runner (hay bị chiếm — xem mục 10.3 để đổi) |
| `` Ctrl+` `` | Mở/đóng terminal |
| `F12` | Nhảy tới định nghĩa hàm |
| `Alt+←` | Quay lại vị trí trước |
| `Shift+Alt+F` | Format file |
| `Ctrl+/` | Comment / bỏ comment dòng |
| `F2` | Đổi tên biến hoặc hàm trên toàn project |
| `Ctrl+P` | Mở nhanh file theo tên |
| `Ctrl+Shift+P` | Command Palette |
| `Alt+↑` / `Alt+↓` | Di chuyển dòng lên / xuống |
| `Ctrl+D` | Chọn thêm từ giống hệt tiếp theo |

---

## 15. Xử lý lỗi thường gặp

### `'gcc' is not recognized as an internal or external command`
PATH chưa đúng hoặc chưa được nạp lại. Kiểm tra thư mục `C:\msys64\ucrt64\bin` có tồn tại không, rồi **đóng hoàn toàn VS Code** (kể cả từ khay hệ thống) và mở lại. VS Code chỉ đọc PATH lúc khởi động.

### `undefined reference to 'sqrt'`
Thiếu thư viện toán. Thêm `"-lm"` vào **cuối** mảng `args` trong `tasks.json`, sau tham số `-o`.

### `undefined reference to 'ten_ham_cua_ban'`
Bạn có nhiều file `.c` nhưng chỉ biên dịch một file. Dùng task `build all c files` hoặc chuyển sang Makefile ở mục 12.

### Nhấn `Ctrl+Alt+N` không có phản ứng gì
Phím tắt bị phần mềm khác chiếm. Chạy tạm bằng **chuột phải → Run Code**, rồi đổi sang phím khác theo mục 10.3.

### `process_begin: CreateProcess(NULL, rm -f ...) failed` khi chạy `make clean`
Makefile đang dùng lệnh `rm` của Linux. Windows không có lệnh này (PowerShell có alias `rm` nhưng `make` gọi trực tiếp qua `CreateProcess`, không qua shell). Dùng Makefile đa nền tảng ở mục 12, hoặc thay dòng `clean` thành:
```makefile
clean:
	-del /Q src\*.o program.exe 2>nul
```
Cách khác: thêm `C:\msys64\usr\bin` vào PATH — thư mục này có `rm.exe`, `cp.exe`, `mkdir.exe` thật. Đánh đổi là nó cũng chứa vài lệnh trùng tên với lệnh Windows (`find`, `sort`), nên hãy đặt nó **sau** các đường dẫn hệ thống trong danh sách PATH.

### `make` build lại toàn bộ mỗi lần dù code không đổi
`TARGET` thiếu đuôi `.exe`. MinGW-GCC tự thêm `.exe` vào file output, nên file thật là `program.exe` trong khi `make` đi tìm `program`. Sửa thành `TARGET = program.exe`. Kiểm tra bằng cách chạy `make` hai lần — lần hai phải báo `Nothing to be done for 'all'.`

### `gcc: fatal error: no input files` khi chạy make
Biến `SRC` rỗng, `make` không tìm thấy file `.c` nào. Xem bảng chẩn đoán chi tiết ở mục 12.2.

### `multiple definition of 'main'` khi chạy make
Bạn có nhiều file cùng chứa hàm `main()` và đang build chung. Dùng `filter-out` để loại bớt (cách B, mục 12.1) hoặc tách thành nhiều target (cách D).

### `Makefile:12: *** missing separator. Stop.`
Dòng lệnh trong Makefile bị thụt bằng **dấu cách** thay vì **phím Tab**. Trong VS Code, mở file Makefile và nhấn `Ctrl+Shift+P` → **Convert Indentation to Tabs**.

### `scanf` không nhận được input
- Với Code Runner: bật `"code-runner.runInTerminal": true`
- Với debug: đổi `"externalConsole": true` trong `launch.json`

### IntelliSense gạch đỏ nhưng biên dịch vẫn thành công
Gạch đỏ là do IntelliSense, không phải compiler. Kiểm tra `compilerPath` trong `c_cpp_properties.json`, rồi `Ctrl+Shift+P` → **C/C++: Reset IntelliSense Database**.

### Breakpoint hiện vòng tròn rỗng, không dừng lại
Thiếu cờ `-g` khi biên dịch. Kiểm tra `args` trong `tasks.json`. Cũng cần chắc `program` trong `launch.json` trỏ đúng file `.exe` mà task vừa tạo ra.

### `Unable to start debugging. Unexpected GDB output`
`miDebuggerPath` sai. Chạy `where gdb` trong Command Prompt để lấy đường dẫn thật, rồi dán vào (nhớ đổi `\` thành `/`).

### `preLaunchTask 'build active file' terminated with exit code 1`
Task build lỗi. Mở tab TERMINAL để xem thông báo lỗi biên dịch thật sự — thường là lỗi cú pháp trong code của bạn.

### `The terminal process failed to launch`
Terminal mặc định có vấn đề. `Ctrl+Shift+P` → **Terminal: Select Default Profile** → chọn **Command Prompt**.

### Windows Defender / antivirus xóa file `.exe` vừa build
File thực thi tự biên dịch đôi khi bị nhận nhầm. Thêm thư mục project vào danh sách loại trừ: **Windows Security → Virus & threat protection → Manage settings → Add or remove exclusions**.

### Vẫn không chạy — cách khoanh vùng lỗi
Mở terminal tích hợp, chạy thủ công:
```cmd
gcc main.c -o main.exe
```
- Lệnh này **chạy được** → lỗi nằm ở `tasks.json`
- Lệnh này **không chạy được** → lỗi nằm ở compiler hoặc PATH, quay lại mục 4–5

---

## 16. Checklist

- [ ] `gcc --version` chạy được trong Command Prompt mới
- [ ] `gdb --version` chạy được
- [ ] VS Code đã cài extension **C/C++** của Microsoft
- [ ] Đã mở một **thư mục** (không phải file lẻ), đường dẫn không dấu tiếng Việt
- [ ] Thư mục `.vscode` có đủ 3 file cấu hình
- [ ] `Ctrl+Shift+B` build thành công, sinh ra file `.exe`
- [ ] Đặt breakpoint, nhấn `F5`, chương trình dừng đúng chỗ và xem được biến
- [ ] `scanf` nhận được số nhập từ bàn phím
- [ ] `Shift+Alt+F` format code hoạt động

Đủ 9 mục là môi trường đã sẵn sàng.

---

## Phụ lục: dùng lại cấu hình cho project mới

Thư mục `.vscode` với 3 file trên có thể **copy nguyên vẹn** sang mọi project C mới — không cần cấu hình lại từ đầu. Nên lưu một bản dự phòng ở đâu đó, ví dụ `D:\code\_vscode-template\`.

Nếu dùng Git, tạo file `.gitignore`:

```gitignore
*.o
*.exe
*.out
program
build/
.vscode/ipch/
```

**Cài thêm thư viện qua MSYS2** (ví dụ SDL2 để làm game 2D):

```bash
pacman -S mingw-w64-ucrt-x86_64-SDL2
```

Tìm tên gói tại <https://packages.msys2.org/>, luôn chọn nhánh `ucrt64`.
