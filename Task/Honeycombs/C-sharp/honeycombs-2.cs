<Window x:Class="Honeycombs.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Honeycomb" Height="400" Width="300" Loaded="Window_Loaded" ResizeMode="NoResize">
    <Grid x:Name="Main" Margin="5,5,5,0">
        <Grid.RowDefinitions>
            <RowDefinition/>
            <RowDefinition Height="69.6"/>
        </Grid.RowDefinitions>
        <TextBlock x:Name="Letters" HorizontalAlignment="Center" TextWrapping="Wrap" Grid.Row="1" VerticalAlignment="Center" FontSize="20"/>
        <Canvas x:Name="HoneycombCanvas" HorizontalAlignment="Center" VerticalAlignment="Center"/>
    </Grid>
</Window>
