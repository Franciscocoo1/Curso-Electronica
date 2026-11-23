`default_nettype none
`timescale 1ns / 1ps

module tb();

    reg clk;
    reg rst_n;
    reg ena;

    reg [7:0] ui_in;
    reg [7:0] uio_in;

    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Instancia del diseño
    tt_um_autoguard uut (
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe)
    );

    // Generador de reloj
    always #5 clk = ~clk;

    initial begin

        // Inicialización
        clk = 0;
        rst_n = 1;
        ena = 1;
        ui_in = 8'b00000000;
        uio_in = 8'b00000000;

        #10;

        // 1. Motor apagado
        ui_in = 8'b00000000;
        #10;

        // 2. Funcionamiento normal
        ui_in = 8'b00000001;
        #10;

        // 3. Temperatura alta
        ui_in = 8'b00000011;
        #10;

        // 4. Aceite bajo
        ui_in = 8'b00000101;
        #10;

        // 5. Refrigerante bajo
        ui_in = 8'b00001001;
        #10;

        // 6. Temperatura + refrigerante
        ui_in = 8'b00001011;
        #10;

        // 7. Aceite + refrigerante
        ui_in = 8'b00001101;
        #10;

        // 8. Temperatura + aceite
        ui_in = 8'b00000111;
        #10;

        // 9. Todas las fallas
        ui_in = 8'b00001111;
        #10;

        $finish;
    end

endmodule
