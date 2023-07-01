function Get-ChineseZodiac
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateRange(1,9999)]
        [int]
        $Year = (Get-Date).Year
    )

    Begin
    {
        $pinyin = @{
            '甲' = 'jiă'
            '乙' = 'yĭ'
            '丙' = 'bĭng'
            '丁' = 'dīng'
            '戊' = 'wù'
            '己' = 'jĭ'
            '庚' = 'gēng'
            '辛' = 'xīn'
            '壬' = 'rén'
            '癸' = 'gŭi'
            '子' = 'zĭ'
            '丑' = 'chŏu'
            '寅' = 'yín'
            '卯' = 'măo'
            '辰' = 'chén'
            '巳' = 'sì'
            '午' = 'wŭ'
            '未' = 'wèi'
            '申' = 'shēn'
            '酉' = 'yŏu'
            '戌' = 'xū'
            '亥' = 'hài'
        }

        $celestial   = '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'
        $terrestrial = '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'
        $animals     = 'Rat', 'Ox', 'Tiger', 'Rabbit', 'Dragon', 'Snake', 'Horse', 'Goat', 'Monkey', 'Rooster', 'Dog', 'Pig'
        $elements    = 'Wood', 'Fire', 'Earth', 'Metal', 'Water'
        $aspects     = 'yang', 'yin'

        $base = 4
    }
    Process
    {
        foreach ($ce_year in $Year)
        {
            $cycle_year     = $ce_year - $base

            $stem_number    = $cycle_year % 10
            $stem_han       = $celestial[$stem_number]
            $stem_pinyin    = $pinyin[$stem_han]

            $element_number = [Math]::Floor($stem_number / 2)
            $element        = $elements[$element_number]

            $branch_number  = $cycle_year % 12
            $branch_han     = $terrestrial[$branch_number]
            $branch_pinyin  = $pinyin[$branch_han]
            $animal         = $animals[$branch_number]

            $aspect_number  = $cycle_year % 2
            $aspect         = $aspects[$aspect_number]

            $index          = $cycle_year % 60 + 1

            [PSCustomObject]@{
                Year        = $Year
                Element     = $element
                Animal      = $animal
                Aspect      = $aspect
                YearOfCycle = $index
                ASCII       = "$stem_pinyin-$branch_pinyin"
                Chinese     = "$stem_han$branch_han"
            }
        }
    }
}
