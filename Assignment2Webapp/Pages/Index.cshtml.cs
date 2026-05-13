using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Azure.Messaging.ServiceBus;
using Azure.Identity;
using System.ComponentModel.DataAnnotations;

namespace Assignment2Webapp.Pages;

public class IndexModel : PageModel
{
    [BindProperty]
    [Required]
    public string? Message { get; set; }

    public string? StatusMessage { get; set; }

    private readonly string? _serviceBusNamespace;
    private readonly string? _serviceBusQueue;
    private readonly string? _serviceBusConnectionString;

    public IndexModel()
    {
        _serviceBusNamespace = Environment.GetEnvironmentVariable("SERVICEBUS_NAMESPACE");
        _serviceBusQueue = Environment.GetEnvironmentVariable("SERVICEBUS_QUEUE");
        _serviceBusConnectionString = Environment.GetEnvironmentVariable("SERVICEBUS_CONNECTION_STRING");
    }

    public void OnGet()
    {
    }

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
        {
            return Page();
        }

        if (string.IsNullOrEmpty(_serviceBusQueue))
        {
            StatusMessage = "Service Bus configuration is missing.";
            return Page();
        }

        try
        {
            await using var client = CreateServiceBusClient();
            ServiceBusSender sender = client.CreateSender(_serviceBusQueue);
            await sender.SendMessageAsync(new ServiceBusMessage(Message));
            StatusMessage = "Message sent successfully!";
        }
        catch (Exception ex)
        {
            StatusMessage = $"Error sending message: {ex.Message}";
        }

        return Page();
    }

    private ServiceBusClient CreateServiceBusClient()
    {
        if (!string.IsNullOrEmpty(_serviceBusConnectionString))
        {
            return new ServiceBusClient(_serviceBusConnectionString);
        }

        if (string.IsNullOrEmpty(_serviceBusNamespace))
        {
            throw new InvalidOperationException("Service Bus namespace is missing.");
        }

        string fullyQualifiedNamespace = _serviceBusNamespace.Contains(".servicebus.windows.net")
            ? _serviceBusNamespace
            : _serviceBusNamespace + ".servicebus.windows.net";

        return new ServiceBusClient(fullyQualifiedNamespace, new DefaultAzureCredential());
    }
}
