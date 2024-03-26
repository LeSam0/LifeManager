using System;
using Avalonia.Controls;

namespace LifeManager;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        
    }
    
    
    private async void Button_Click(object sender, Avalonia.Interactivity.RoutedEventArgs e)
    {
        string data = await LifeManager.TestApi.GetApiData();
        Console.WriteLine(data);
    }
    
    
}