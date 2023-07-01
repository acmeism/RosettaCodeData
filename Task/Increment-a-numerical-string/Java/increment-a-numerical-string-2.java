String s = "123456789012345678901234567890.12345";
s = new BigDecimal(s).add(BigDecimal.ONE).toString();
