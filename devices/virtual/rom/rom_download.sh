set -xe
wget  -O rom.zip https://bigota.d.miui.com/V12.5.6.0.RJFMIXM/miui_CITRUSGlobal_V12.5.6.0.RJFMIXM_0daef7544e_11.0.zip
SHA256_HASH="00b2e3a3530c8fc5963d6f8bd8b061fee21a106ca09d5426fbe2c5be1fa3da40"
echo "${SHA256_HASH}  rom.zip" | shasum -a 256 --check
