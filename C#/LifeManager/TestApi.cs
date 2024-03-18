using System.Threading.Tasks;

namespace LifeManager;

public class TestApi
{
    public static async Task<string> GetApiData()
    {
        string apiUrl = "http://localhost:8000/courses";
        try
        {
            using (var client = new System.Net.Http.HttpClient())
            {
                System.Net.Http.HttpResponseMessage response = await client.GetAsync(apiUrl);
                if (response.IsSuccessStatusCode)
                {
                    string content = await response.Content.ReadAsStringAsync();
                    System.Console.WriteLine(content);
                    return content;
                }
                else
                {
                    return null;
                }
            }
        }
        catch (System.Exception e)
        {
            System.Console.WriteLine(e.Message);
            return "Pas Co";
        }
    }
}