int crc16(List<int> data, {int offset = 0}) {
  int length = data.length;
  int crc = 0x0000;
  for (int i = 0; i < length; i++) {
    crc ^= data[offset + i] << 8;
    for (int j = 0; j < 8; j++) {
      if ((crc & 0x8000) > 0) {
        crc = (crc << 1) ^ 0x1021;
      } else {
        crc = crc << 1;
      }
    }
  }
  return crc & 0xFFFF;
}
