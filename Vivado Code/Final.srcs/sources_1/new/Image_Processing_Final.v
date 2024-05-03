`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2021 10:53:47 AM
// Design Name: 
// Module Name: Image_Processing_Final
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Image_Processing_Final(
clock,reset,sel_module,val,        
hsync,vsync,                        
red, green, blue                    
);
    input clock;
    input reset;
    input [7:0] val = 0;            
    input[3:0] sel_module;          
    reg[7:0] red_o, blue_o, green_o;            
    reg [15:0] r, b, g;                         
    
    reg clk;
    initial begin
    clk =0;
    end
    always@(posedge clock)
    begin
     clk<=~clk;
    end
 
   output reg hsync;
   output reg vsync;
   reg [7:0] tred,tgreen,tblue;
	output reg [3:0] red,green;
	output reg [3:0] blue;

	reg read = 0;
	reg [14:0] addra = 0;
	reg [95:0] in1 = 0;
	wire [95:0] out2;
		
blk_mem_gen_0  inst1(
  .clka(clk), 
  .wea(read), 
  .addra(addra),
  .dina(in1), 
  .douta(out2) 
);

   wire pixel_clk;
   reg 		pcount = 0;
   wire 	ec = (pcount == 0);  
   always @ (posedge clk) pcount <= ~pcount;
   assign 	pixel_clk = ec;
   reg 		hblank=0,vblank=0;
   initial begin
   hsync =0;
   vsync=0;
   end
   
   reg [9:0] 	hc=0;      
   reg [9:0] 	vc=0;	 
	
   wire 	hsyncon,hsyncoff,hreset,hblankon;
   assign 	hblankon = ec & (hc == 639);    
   assign 	hsyncon = ec & (hc == 655);
   assign 	hsyncoff = ec & (hc == 751);
   assign 	hreset = ec & (hc == 799);
   
   wire 	blank =  (vblank | (hblank & ~hreset));    
   
   wire 	vsyncon,vsyncoff,vreset,vblankon;
   assign 	vblankon = hreset & (vc == 479);    
   assign 	vsyncon = hreset & (vc == 490);
   assign 	vsyncoff = hreset & (vc == 492);
   assign 	vreset = hreset & (vc == 523);

   always @(posedge clk) begin
   hc <= ec ? (hreset ? 0 : hc + 1) : hc;
   hblank <= hreset ? 0 : hblankon ? 1 : hblank;
   hsync <= hsyncon ? 0 : hsyncoff ? 1 : hsync; 
   
   vc <= hreset ? (vreset ? 0 : vc + 1) : vc;
   vblank <= vreset ? 0 : vblankon ? 1 : vblank;
   vsync <= vsyncon ? 0 : vsyncoff ? 1 : vsync;
end

always @(posedge pixel_clk)
	begin		
            if(blank == 0 && hc >= 320 && hc < 480 && vc >= 205 && vc < 320)
            begin
                tblue =  {out2[23], out2[22], out2[21], out2[20], out2[19], out2[18], out2[17], out2[16]};
                tgreen = {out2[15], out2[14], out2[13], out2[12], out2[11], out2[10], out2[9], out2[8]};
                tred = {out2[7], out2[6], out2[5], out2[4], out2[3], out2[2], out2[1], out2[0]};

              //Displaying original image
              if(sel_module == 4'b0000)begin              
                    if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                    end else begin
                        red_o=tred;
                        blue_o=tblue;
                        green_o=tgreen;
                        
                        red_o = red_o/16;
                        blue_o = blue_o/16;
                        green_o = green_o/16;

                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};                        
                    end
                
              //RGB image to gray scale image
             end else if(sel_module == 4'b0001)begin              
                    if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                    end else begin
                        red_o = (tred >> 2) + (tred >> 5) + (tgreen >> 1) + (tgreen >> 4)+ (tblue >> 4) + (tblue >> 5);
                        green_o = (tred >> 2) + (tred >> 5) + (tgreen >> 1) + (tgreen >> 4)+ (tblue >> 4) + (tblue >> 5);
                        blue_o = (tred >> 2) + (tred >> 5) + (tgreen >> 1) + (tgreen >> 4)+ (tblue >> 4) + (tblue >> 5);
                        
                        red_o = red_o/16;
                        blue_o = blue_o/16;
                        green_o = green_o/16;

                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};                        
                    end
                
                    // Increase brightness
                end else if(sel_module == 4'b0010)begin                
                    if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                    end else begin
                        r = tred + val;
                        g = tgreen + val;
                        b = tblue + val;
                        if(r > 255)begin
                            red_o = 255;
                        end else begin
                            red_o = r;
                        end
                        if(g > 255)begin
                            green_o = 255;
                        end else begin
                            green_o = g;
                        end
                        if(b > 255)begin
                            blue_o = 255;
                        end else begin
                            blue_o = b;
                        end
                        
                        red_o = red_o/16;
                        blue_o = blue_o/16;
                        green_o = green_o/16;
                       
                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};
                    end
                    
                    // Decrease brightness
                end else if(sel_module == 4'b0011)begin
                    if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                    end else begin
                        r = tred - val;
                        g = tgreen - val;
                        b = tblue - val;
                        if(r > 256)begin
                            red_o = 0;
                        end else begin
                            red_o = r;
                        end
                        if(g > 256)begin
                            green_o = 0;
                        end else begin
                            green_o = g;
                        end
                        if(b > 256)begin
                            blue_o = 0;
                        end else begin
                            blue_o = b;
                        end
                        
                        red_o = red_o >> 4;
                        blue_o = blue_o >> 4;
                        green_o = green_o >> 4 ;  
                        
                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};
                    end
                    
                    // colour inversion
                end else if(sel_module == 4'b0100)begin
                    if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                    end
                    else begin
                        red_o = 255 - tred;
                        green_o = 255 - tgreen;
                        blue_o = 255 - tblue;
                        
                        red_o = red_o >> 4;
                        blue_o = blue_o >> 4;
                        green_o = green_o >> 4 ;               
                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};
                        end                                           
               end            
                
                if(addra <18399)
                    addra = addra + 1;
                else
                    addra = 0;
            end
                       
            else
            begin            
                red = 0;
                green = 0;
                blue = 0;                
            end
        end    
       
    endmodule


