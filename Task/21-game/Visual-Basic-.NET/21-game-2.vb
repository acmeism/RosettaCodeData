<Window x:Class="MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Game21vb"
        mc:Ignorable="d"
        Title="Game 21" Height="292" Width="409" Loaded="StartGame">
    <Grid>
        <TextBlock
            HorizontalAlignment="Left" Margin="10,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="64" Width="376">
            Game 21 is a two player game, the game is played by choosing a number (1, 2, or 3) to be added to the running total.
            The game is won by the player whose chosen number causes the running total to reach exactly 21.
            The running total starts at zero.
        </TextBlock>
        <Label Content="AI" HorizontalAlignment="Left" Margin="60,121,0,0" VerticalAlignment="Top" Width="49" HorizontalContentAlignment="Right"/>
        <Label Content="Human" HorizontalAlignment="Left" Margin="60,152,0,0" VerticalAlignment="Top" HorizontalContentAlignment="Right"/>
        <Label Content="Total" HorizontalAlignment="Left" Margin="60,183,0,0" VerticalAlignment="Top" Width="49" HorizontalContentAlignment="Right"/>
        <TextBox x:Name="boxAI" HorizontalAlignment="Left" Height="23" Margin="114,125,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120" IsReadOnly="True"/>
        <TextBox x:Name="boxHuman" HorizontalAlignment="Left" Height="23" Margin="114,156,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120" IsReadOnly="True"/>
        <TextBox x:Name="boxTotal" HorizontalAlignment="Left" Height="23" Margin="114,187,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120" IsReadOnly="True"/>
        <Button x:Name="button1" Content="1" HorizontalAlignment="Left" Margin="114,220,0,0" VerticalAlignment="Top" Width="25"/>
        <Button x:Name="button2" Content="2" HorizontalAlignment="Left" Margin="144,220,0,0" VerticalAlignment="Top" Width="25"/>
        <Button x:Name="button3" Content="3" HorizontalAlignment="Left" Margin="174,220,0,0" VerticalAlignment="Top" Width="25"/>
        <Button x:Name="restart" Content="restart" HorizontalAlignment="Left" Margin="215,220,0,0" VerticalAlignment="Top" Width="75"/>
        <Label x:Name="winner" HorizontalAlignment="Left" Margin="245,184,0,0" VerticalAlignment="Top" Width="133"/>
        <Label x:Name="first" HorizontalAlignment="Left" Margin="10,79,0,0" VerticalAlignment="Top"/>
    </Grid>
</Window>
