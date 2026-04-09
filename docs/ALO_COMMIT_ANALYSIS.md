# Phân tích lịch sử commit — `alo/FFmpeg-Builds-SVT-AV1-HDR`

Tài liệu này tổng hợp phân tích nhánh Git tại `D:\DaPlex\alo\FFmpeg-Builds-SVT-AV1-HDR`, remote `https://github.com/vghuy17ck1/FFmpeg-Builds-SVT-AV1-HDR.git`, HEAD `1b024ab` (2026-02-22). Mục đích: ghi lại ý nghĩa các thay đổi để đối chiếu với fork `yacucdeptrai/FFmpeg-Builds-SVT-AV1-HDR`.

## Tổng quan

- **Trọng tâm fork**: tích hợp **SVT-AV1 HDR** (và biến thể **svt-av1-psyex**) thay cho upstream BtbN thuần; giữ pipeline Docker/GitHub Actions build đa nền tảng.
- **Nhóm commit gần nhất (2026)**: mở rộng biến thể **nonfree**, vá lỗi build tĩnh Windows (OpenCL, libssh), cập nhật dependency, chỉnh libplacebo/Vulkan, nâng Node trong image.

## Các mốc commit đáng chú ý (mới → cũ)

| Commit   | Thông điệp | Ý nghĩa kỹ thuật |
|----------|------------|------------------|
| `1b024ab` | add nonfree variants | Thêm/cấu hình biến thể **nonfree** trong ma trận CI (gpl + nonfree song song). |
| `a0aca87` | svt-av1-hdr e8903e9 | Ghim **SVT-AV1 HDR** tại commit `e8903e9` trong script tải/build. |
| `d6cf260` | svt-av1-psyex v3.0.2-B | Tích hợp nhánh/build **psyex** cụ thể (v3.0.2-B). |
| `edfe72e` | OpenCL loader DllMain | Vượt qua xung đột **DllMain** khi link tĩnh với OpenCL trên Windows. |
| `4ab8a39` | libssh global symbol | Workaround ký hiệu toàn cục generic của **libssh**. |
| `d7c5a29` | mingw headers winarm | Override header MinGW cho **winarm64**. |
| `fd8c2e5` | Update dependencies | Đồng bộ phiên bản thư viện phụ thuộc (scripts.d). |
| `40fd461` | libplacebo vulkan shim | **libplacebo** dùng Vulkan shim loader (tương thích BtbN). |
| `28ee7a1` | NodeJS 24.x | Nâng Node trong image build. |
| `b2d189b` / `bc8cf12` | SVT-AV1 downgrade / update | Điều chỉnh phiên bản **SVT-AV1** theo phá vỡ API upstream. |

Các commit cũ hơn (2025 trở về trước) chủ yếu: bổ sung **glslc**, kiểm tra phiên bản **ffnvcodec/dav1d/vmaf/vulkan/frei0r/...**, cài **wine/qemu** cho test, cập nhật dependency định kỳ.

## Khác biệt so với clone tại `D:\DaPlex\FFmpeg-Builds-SVT-AV1-HDR`

- Repo gốc trong workspace này nhắm fork **`yacucdeptrai/FFmpeg-Builds-SVT-AV1-HDR`**, thường **mới hơn** về ma trận FFmpeg **8.1**, thêm base image/arch (mips/ppc/riscv) và patch `8.1.patch`; bản **alo** neo mạnh vào dòng **8.0** và **nonfree** theo commit 2026-02-22.
- Khi cần **port** một thay đổi từ alo sang fork chính: đối chiếu từng `scripts.d/*.sh` và `patches/ffmpeg/*`, rồi chạy `./generate.sh` / CI tương ứng.

## Workflow GitHub Actions

Fork cá nhân cần chỉnh bước **Repo Check** trong `.github/workflows/build.yml` để `GITHUB_REPOSITORY` khớp `owner/repo` của fork (ví dụ `yacucdeptrai/FFmpeg-Builds-SVT-AV1-HDR`) và random hóa `cron` schedule để tránh tải trùng hạ tầng upstream.

---
*Phân tích dựa trên `git log` cục bộ và cấu trúc repo; ContextPlus semantic search không khả dụng trong phiên làm việc này (fetch failed).*
