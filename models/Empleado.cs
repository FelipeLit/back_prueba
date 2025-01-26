namespace backend.models
{
    public class Empleado
    {
        public int IdEmpleado { get; set; }
        public string? Nombre { get; set; }
        public string? Correo { get; set; }
        public decimal Sueldo { get; set; }
        public string? FechaContrato { get; set; }

    }
}