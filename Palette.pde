public color getColor() {
  return getColor(0);
}

public color getColor(int idx) {
  idx += colorOffset;
  int len = Config.PALETTE.length;

  while(idx>=len) idx-=len;
  while(idx<0) idx+=len;

  return Config.PALETTE[idx];
}
