# Điều kiện tiên quyết

- Hãy cài đặt đầy đủ plugin Dart và Flutter trên nền tảng IDE sử dụng.
- Kiểm tra flutter đã được cài trên máy tính cha bằng cách nhập 'flutter doctor' trên terminal
- Để có thể có được UI chính xác nhất từ project nên tạo thiết bị như sau:
 Device Manager => Create Device => Phone Pixel 6 => API 33 => Show advanced settings => Custom skin definition => pixel_6_pro
- Vì project sử dụng database là Firebase nên nếu thầy cần xem database mong thầy gửi mail qua 2051050559vang@ou.edu.vn để bọn em thêm thầy vào Firestore của project.

# Hướng dẫn cài Flutter

- Link tải Flutter SDK và hướng dẫn cài đặt: https://docs.flutter.dev/get-started/install/windows

# Hướng dẫn cài plugin cho Android Studio và Visual Studio Code

**Đổi với Android Studio các bạn làm như sau:**

Khởi động Android Studio
Ở màn hình Welcome to Android Studio, mở menu Configure (phía dưới góc phải), chọn Plugins
Ở tab Marketplace, các bạn search “flutter”, bạn nhấn install vào plugin Flutter ngay kết quả đầu tiên.
Plugin này yêu cầu chúng ta cài đặt thêm một plugin nữa là Dart, chọn Yes để cho phép cài đặt Dart nữa.
Chúng ta cần RESTART IDE để áp dụng thay đổi

**Đối với Visual Studio Code, các bạn làm như sau:**

Mở Visual Studio Code
Vào tab Extentions trên thanh sidebar bên trái
Search “flutter”, chúng ta nhấn Install plugin đầu tiên của kết quả tìm kiếm. Khác với Android Studio,
khi cài plugin Flutter thì plugin Dart cũng sẽ được tự cài theo mà không cần bạn xác nhận.

# Hướng dẫn sau khi clone project về

**_Lưu ý:_**

- Cần phải vào terminal chạy câu lệnh "flutter pub get" để lấy tất cả các Dependencies cần thiết cho project.