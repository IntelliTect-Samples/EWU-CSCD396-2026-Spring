using Azure.Identity;
using Azure.Messaging.ServiceBus;
using Azure.Storage.Blobs;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace Assignment3.FunctionApp.Functions;

public class ServiceBusMessageToBlob
{
    private readonly ILogger<ServiceBusMessageToBlob> _logger;

    public ServiceBusMessageToBlob(ILogger<ServiceBusMessageToBlob> logger)
    {
        _logger = logger;
    }

    [Function(nameof(ServiceBusMessageToBlob))]
    public async Task Run(
        [ServiceBusTrigger("%ServiceBusQueueName%", Connection = "ServiceBusConnection")]
        ServiceBusReceivedMessage message)
    {
        var storageEndpoint = GetRequiredSetting("StorageAccountBlobEndpoint");
        var outputContainer = GetRequiredSetting("OutputContainer");

        var blobServiceClient = new BlobServiceClient(new Uri(storageEndpoint), new DefaultAzureCredential());
        var containerClient = blobServiceClient.GetBlobContainerClient(outputContainer);
        await containerClient.CreateIfNotExistsAsync();

        var blobName = CreateBlobName(message);
        var blobClient = containerClient.GetBlobClient(blobName);
        var messageText = message.Body.ToString();

        await blobClient.UploadAsync(BinaryData.FromString(messageText), overwrite: false);

        _logger.LogInformation(
            "Wrote Service Bus message {MessageId} to blob {BlobName}.",
            message.MessageId,
            blobName);
    }

    private static string GetRequiredSetting(string name)
    {
        return Environment.GetEnvironmentVariable(name)
            ?? throw new InvalidOperationException($"Missing required app setting '{name}'.");
    }

    private static string CreateBlobName(ServiceBusReceivedMessage message)
    {
        var receivedAt = DateTimeOffset.UtcNow;
        var messageId = string.IsNullOrWhiteSpace(message.MessageId)
            ? Guid.NewGuid().ToString("N")
            : SanitizeBlobSegment(message.MessageId);

        return $"messages/{receivedAt:yyyy/MM/dd/HHmmssfff}-{messageId}.txt";
    }

    private static string SanitizeBlobSegment(string value)
    {
        var invalidCharacters = Path.GetInvalidFileNameChars();
        var sanitized = new string(value
            .Select(character => invalidCharacters.Contains(character) ? '-' : character)
            .ToArray());

        return string.IsNullOrWhiteSpace(sanitized) ? Guid.NewGuid().ToString("N") : sanitized;
    }
}
