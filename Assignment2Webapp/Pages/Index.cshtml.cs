using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Azure.Messaging.ServiceBus;
using Azure.Identity;
using System.ComponentModel.DataAnnotations;
using System;
using System.Threading.Tasks;

namespace Assignment2Webapp.Pages;

public class IndexModel : PageModel
{
    [BindProperty]
    [Required]
    public string? Message { get; set; }

    public string? StatusMessage { get; set; }

    private readonly string? _serviceBusNamespace;
    private readonly string? _serviceBusQueue;

    public IndexModel()
    {
        _serviceBusNamespace = Environment.GetEnvironmentVariable("SERVICEBUS_NAMESPACE");
        _serviceBusQueue = Environment.GetEnvironmentVariable("SERVICEBUS_QUEUE");
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

        if (string.IsNullOrEmpty(_serviceBusNamespace) || string.IsNullOrEmpty(_serviceBusQueue))
        {
            StatusMessage = "Service Bus configuration is missing.";
            return Page();
        }

        try
        {
            string fullyQualifiedNamespace = _serviceBusNamespace.Contains(".servicebus.windows.net")
                ? _serviceBusNamespace
                : _serviceBusNamespace + ".servicebus.windows.net";

            var client = new ServiceBusClient(fullyQualifiedNamespace, new DefaultAzureCredential());
            var sender = client.CreateSender(_serviceBusQueue);
            await sender.SendMessageAsync(new ServiceBusMessage(Message));
            StatusMessage = "Message sent successfully!";
        }
        catch (Exception ex)
        {
            StatusMessage = $"Error sending message: {ex.Message}";
        }

        return Page();
    }
}
