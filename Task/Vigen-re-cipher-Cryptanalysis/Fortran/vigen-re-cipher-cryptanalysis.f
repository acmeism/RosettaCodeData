module vigenere_cipher
  use, intrinsic :: iso_fortran_env, only: real64, int32
  implicit none

  private
  public :: vigenere_decrypt

  type :: FreqPair
    character :: c
    real(real64) :: freq
  end type FreqPair

contains

  function frequency(input_text, input_len) result(freq_result)
    integer(int32), intent(in) :: input_text(:), input_len
    type(FreqPair), allocatable :: freq_result(:)
    integer :: i

    allocate(freq_result(26))
    do i = 1, 26
      freq_result(i)%c = achar(64 + i)
      freq_result(i)%freq = 0.0_real64
    end do

    do i = 1, input_len
      freq_result(input_text(i) - 64)%freq = freq_result(input_text(i) - 64)%freq + 1
    end do
  end function frequency

  function correlation(input_text, input_len, sorted_targets) result(corr)
    integer(int32), intent(in) :: input_text(:), input_len
    real(real64), intent(in) :: sorted_targets(:)
    real(real64) :: corr
    type(FreqPair), allocatable :: freq(:)
    integer :: i, j
    type(FreqPair) :: temp

    freq = frequency(input_text, input_len)

    ! Sort freq by frequency
    do i = 1, 25
      do j = i + 1, 26
        if (freq(j)%freq > freq(i)%freq) then
          temp = freq(j)
          freq(j) = freq(i)
          freq(i) = temp
        end if
      end do
    end do

    corr = 0.0_real64
    do i = 1, 26
      corr = corr + freq(i)%freq * sorted_targets(i)
    end do

    deallocate(freq)
  end function correlation

  subroutine vigenere_decrypt(target_freqs, encoded, out_key, out_text)
      implicit none
    real(real64), intent(in) :: target_freqs(:)
    character(len=*), intent(in) :: encoded
    character(len=:), allocatable, intent(out) :: out_key, out_text
    integer(int32), allocatable :: cleaned(:)
    integer :: cleaned_len, i, j, k, best_len, key_len, shift
    real(real64) :: best_corr, corr, max_corr
    real(real64), allocatable :: sorted_targets(:)
    integer(int32), allocatable :: pieces(:), piece_lens(:), current_piece(:)
    character(len=:), allocatable :: temp_key

    ! Clean input text
    allocate(cleaned(len(encoded)))
    cleaned_len = 0
    do i = 1, len(encoded)
      if (encoded(i:i) >= 'A' .and. encoded(i:i) <= 'Z') then
        cleaned_len = cleaned_len + 1
        cleaned(cleaned_len) = iachar(encoded(i:i))
      end if
    end do

    ! Sort target frequencies
    allocate(sorted_targets(26))
    sorted_targets = target_freqs
    call sort_array(sorted_targets)

    ! Find best key length
    best_len = 0
    best_corr = -100.0_real64

    do key_len = 2,cleaned_len/20
      allocate(pieces(cleaned_len), piece_lens(key_len))
      pieces = cleaned
      piece_lens = 0
      do j = 1, cleaned_len
        piece_lens(mod(j-1, key_len) + 1) = piece_lens(mod(j-1, key_len) + 1) + 1
      end do

      corr = -0.5_real64 * key_len
      do i = 1, key_len
        allocate(current_piece(piece_lens(i)))
        k = 0
        do j = i, cleaned_len, key_len
          k = k + 1
          current_piece(k) = pieces(j)
        end do
        corr = corr + correlation(current_piece, piece_lens(i), sorted_targets)
        deallocate(current_piece)
      end do

      if (corr > best_corr) then
        best_len = key_len
        best_corr = corr
      end if

      deallocate(pieces, piece_lens)
    end do

    ! Find key
    allocate(character(len=best_len) :: temp_key)
    do i = 1, best_len
      allocate(pieces(cleaned_len/best_len + 1))
      k = 0
      do j = i, cleaned_len, best_len
        k = k + 1
        pieces(k) = cleaned(j)
      end do

      max_corr = 0.0_real64
      do concurrent (shift = 0:25)
        corr = 0.0_real64
        do j = 1, k
          corr = corr + target_freqs(mod(pieces(j) - 65 - shift + 26, 26) + 1)
        end do
        if (corr > max_corr) then
          max_corr = corr
          temp_key(i:i) = achar(shift + 65)
        end if
      end do
      deallocate(pieces)
    end do
    out_key = temp_key

    ! Decrypt
    allocate(character(len=cleaned_len) :: out_text)
    do i = 1, cleaned_len
      k = iachar(out_key(mod(i-1, best_len) + 1:mod(i-1, best_len) + 1)) - 65
      out_text(i:i) = achar(mod(cleaned(i) - 65 - k + 26, 26) + 65)
    end do
  end subroutine vigenere_decrypt

  subroutine sort_array(arr)
    real(real64), intent(inout) :: arr(:)
    integer :: i, j
    real(real64) :: temp

    do i = 1, size(arr) - 1
      do j = i + 1, size(arr)
        if (arr(j) > arr(i)) then
          temp = arr(j)
          arr(j) = arr(i)
          arr(i) = temp
        end if
      end do
    end do
  end subroutine sort_array

end module vigenere_cipher

program main
  use vigenere_cipher
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none

  real(real64) :: english_freqs(26) = [ &
    0.08167, 0.01492, 0.02782, 0.04253, 0.12702, 0.02228, 0.02015, &
    0.06094, 0.06966, 0.00153, 0.00772, 0.04025, 0.02406, 0.06749, &
    0.07507, 0.01929, 0.00095, 0.05987, 0.06327, 0.09056, 0.02758, &
    0.00978, 0.02360, 0.00150, 0.01974, 0.00074 ]

  character(len=*), parameter :: encoded = &
    "MOMUD EKAPV TQEFM OEVHP AJMII CDCTI FGYAG JSPXY ALUYM NSMYH" // &
    "VUXJE LEPXJ FXGCM JHKDZ RYICU HYPUS PGIGM OIYHF WHTCQ KMLRD" // &
    "ITLXZ LJFVQ GHOLW CUHLO MDSOE KTALU VYLNZ RFGBX PHVGA LWQIS" // &
    "FGRPH JOOFW GUBYI LAPLA LCAFA AMKLG CETDW VOELJ IKGJB XPHVG" // &
    "ALWQC SNWBU BYHCU HKOCE XJEYK BQKVY KIIEH GRLGH XEOLW AWFOJ" // &
    "ILOVV RHPKD WIHKN ATUHN VRYAQ DIVHX FHRZV QWMWV LGSHN NLVZS" // &
    "JLAKI FHXUF XJLXM TBLQV RXXHR FZXGV LRAJI EXPRV OSMNP KEPDT" // &
    "LPRWM JAZPK LQUZA ALGZX GVLKL GJTUI ITDSU REZXJ ERXZS HMPST" // &
    "MTEOE PAPJH SMFNB YVQUZ AALGA YDNMP AQOWT UHDBV TSMUE UIMVH" // &
    "QGVRW AEFSP EMPVE PKXZY WLKJA GWALT VYYOB YIXOK IHPDS EVLEV" // &
    "RVSGB JOGYW FHKBL GLXYA MVKIS KIEHY IMAPX UOISK PVAGN MZHPW" // &
    "TTZPV XFCCD TUHJH WLAPF YULTB UXJLN SIJVV YOVDJ SOLXG TGRVO" // &
    "SFRII CTMKO JFCQF KTINQ BWVHG TENLH HOGCS PSFPV GJOKM SIFPR" // &
    "ZPAAS ATPTZ FTPPD PORRF TAXZP KALQA WMIUD BWNCT LEFKO ZQDLX" // &
    "BUXJL ASIMR PNMBF ZCYLV WAPVF QRHZV ZGZEF KBYIO OFXYE VOWGB" // &
    "BXVCB XBAWG LQKCM ICRRX MACUO IKHQU AJEGL OIJHH XPVZW JEWBA" // &
    "FWAML ZZRXJ EKAHV FASMU LVVUT TGK"

  character(len=:), allocatable :: key, decoded
  integer :: xx,yy
  call system_clock(count=xx)

  call vigenere_decrypt(english_freqs, encoded, key, decoded)
  call system_clock(count=yy)

  print *, "Key: ", key
  print *, "Decoded text: "

block
    INTEGER :: start, end, length, chunk_size
    ! Define the chunk size
    chunk_size = 80
    ! Get the length of the string
    length = LEN_TRIM(decoded)

    ! Print the string in chunks of 80 characters
    DO start = 1, length, chunk_size
        end = MIN(start + chunk_size - 1, length)
        PRINT *, decoded(start:end)
    END DO
end block
  print '(/,a,1x,i0,1x,a)', 'Decoded in =',(yy-xx), 'milliseconds'
end program main
