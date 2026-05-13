using System;
using System.IO;
using System.Threading.Tasks;
using Azure.Identity;
using Azure.Messaging.ServiceBus;
using Azure.Storage.Blobs;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace Assn4FunctionProj.SendLogs
{
    public class ServiceBusToBlobFunction
    {
        private readonly ILogger _logger;
        private readonly string? _storageAccountUrl;
        private readonly string? _containerName;

        public ServiceBusToBlobFunction(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<ServiceBusToBlobFunction>();
            _storageAccountUrl = Environment.GetEnvironmentVariable("STORAGE_ACCOUNT_URL");
            _containerName = Environment.GetEnvironmentVariable("OutputContainer");
        }

        [Function("ServiceBusToBlobFunction")]
        public async Task Run([ServiceBusTrigger("messages", Connection = "ServiceBusConnection")] string myQueueItem)
        {
            _logger.LogInformation($"Received message: {myQueueItem}");

            if (string.IsNullOrEmpty(_storageAccountUrl) || string.IsNullOrEmpty(_containerName))
            {
                _logger.LogError("Storage configuration missing.");
                return;
            }

            try
            {
                var blobServiceClient = new BlobServiceClient(new Uri(_storageAccountUrl), new DefaultAzureCredential());
                var containerClient = blobServiceClient.GetBlobContainerClient(_containerName);
                await containerClient.CreateIfNotExistsAsync();

                string blobName = $"message-{Guid.NewGuid()}.txt";
                var blobClient = containerClient.GetBlobClient(blobName);
                using var ms = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(myQueueItem));
                await blobClient.UploadAsync(ms);
                _logger.LogInformation($"Message written to blob: {blobName}");
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error writing to blob: {ex.Message}");
            }
        }
    }
}
