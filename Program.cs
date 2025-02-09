using Microsoft.Extensions.Options;
using backend.data;
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<EmpleadoData>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("Nuevapolitica", app =>
    {
        app.AllowAnyOrigin()
        .AllowAnyHeader()
        .AllowAnyMethod();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.

app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("Nuevapolitica");
app.UseAuthorization();
app.UseHttpsRedirection();

app.MapControllers();
app.Run();
