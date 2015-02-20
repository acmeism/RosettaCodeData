<Window x:Class="Sutherland.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Sutherland Hodgman" Background="#B0B0B0" ResizeMode="CanResizeWithGrip" Width="525" Height="450">
    <Grid Margin="4">
        <Grid.RowDefinitions>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="auto"/>
        </Grid.RowDefinitions>

        <Border Grid.Row="0" CornerRadius="4" BorderBrush="#707070" Background="#FFFFFF" BorderThickness="2">
            <Canvas Name="canvas"/>
        </Border>

        <UniformGrid Grid.Row="1" Rows="1" Margin="0,4,0,0">
            <Button Name="btnTriRect" Content="Triangle - Rectangle" Margin="4,0" Click="btnTriRect_Click"/>
            <Button Name="btnConvex" Content="Concave - Convex" Click="btnConvex_Click"/>
        </UniformGrid>
    </Grid>
</Window>
