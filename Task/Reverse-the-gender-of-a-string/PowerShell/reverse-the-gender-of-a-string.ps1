function Switch-Gender ([string]$String)
{
    if ($String -match "She")
    {
        $String.Replace("She", "He")
    }
    elseif ($String -match "He")
    {
        $String.Replace("He", "She")
    }
    else
    {
        $String
    }
}

Switch-Gender "She was a soul stripper. She took my heart!"
Switch-Gender (Switch-Gender "She was a soul stripper. She took my heart!")
