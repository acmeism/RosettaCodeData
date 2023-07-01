def lpad($len; $fill): tostring | ($len - length) as $l | ($fill * $l)[:$l] + .;
def lpad($len): lpad($len; " ");
def lpad: lpad(4);
