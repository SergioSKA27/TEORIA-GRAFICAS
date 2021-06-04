require 'ruby2d'

=begin
Para ejecutar la aplicacion tenemos que haber instalado previamente 
la gema de ruby2d.
=end
set title: 'Gaficas'
set background: 'white'
set width: 1280
set height: 720 
set resizable: true




=begin
    Creamos una clase nodo la cual nos ayudara  a poder mostrar de forma  grafica 
    los elementos que componen nuestra grafica y las relaciones entre los  mismos.
    la clase Node recibe como parametros  el identificador del nodo que  queremos 
    construir(este tiene que tener el metodo to_s para que sea valido), los nodos
    adyacentes al nodo y el tipo de grafica que estamos empleando.
=end



class Node
    attr_reader :id, :ady,:graph_type , :nodes
=begin
    id nos ayuda a  guardar el  identificador  del  nodo, ady  nos  ayuda a  guardar un array con  los
    nodos adyacentes al nodo en cuestion, graph_type guarda el tipo de grafica que se esta utilizando.
=end
    attr_reader :fig  
    #las hitbox nos ayudan apoder determinar el area que ocupan los nodos, para asi saber 
    #cuando el usuario se posiciona encima de un nodo
    def initialize(id,ady,gtype)
        #Para crear un nodo escogemos un color al azar de alguno de los que se encuentran a continuacion
        colors = ['black', 'green', 'blue', 'navy', 'lime', 'aqua',
        'olive', 'yellow', 'orange', 'red', 'brown', 'fuchsia', 'purple',
        'maroon', 'gray']
        @ady = ady 
        @graph_type = gtype 

        #cada nodo se compone de un Shape circle de Ruby2d
        #seleccionamos una posicion aleatoria detro de los 
        #limites establecidos
        @fig = Circle.new(
            x:rand(800)+11 , y: rand(650)+31,
            radius: 30, sectors: 50,
            color: colors[rand(colors.length)],
            z: 10
        )

        

        @id = Text.new(
            id.to_s ,x: self.fig.x-5 ,
            y: self.fig.y-6, color: 'white',
            size: 15, z: 10
        )
    end

    def is_in_node(x,y)#determina si el mouse esta en el nodo
        if self.fig.contains? x,y then
            true
        else 
            false 
        end
    end


    def pos_x
        return self.fig.x
    end


    def remove
        self.fig.remove
        self.id.remove
    end

    def pos_y
        return self.fig.y
    end


    def move(x,y)
        self.fig.x = x
        self.fig.y = y
        self.id.x = self.fig.x-5
        self.id.y = self.fig.y-6
    end
end






class LinesD
    attr_reader :lined, :fr, :fc
    #la clase de lineas para graficas dirigidas recibe como parametros los nodos que queremos unir 
    #siendo el primer parametro el nodo de salida y el segundo el de entrada.
    def initialize(node_s , node_r)
    
        @lined = Line.new(
            x1: node_s.pos_x, y1: node_s.pos_y,
            x2: node_r.pos_x, y2: node_r.pos_y, color: 'black',
            z: 10)
        
    end
end

class Graph
    attr_reader :lines , :nods, :graph_typ
    
    def initialize(nodes, lines, gtype)
        n = []
        pos = [] 
        for i in 0...nodes do
            x =  Node.new(i+1,[], gtype)

            for c in pos do
                if c[0] and c[1]  then
                    if (x.pos_x == c[0] and x.pos_y == c[1] ) or ((x.pos_x <= c[0]+30 and x.pos_x >= c[0]-30) or (x.pos_y >= c[1]-30 and x.pos_y <= c[1]+30))
                        x.remove
                        x =  Node.new(i+1,[], gtype)
                    end
                end
            end

            n.append(x)
            pos.append([x.pos_x, x.pos_y])
        end

        @nods = n
        @graph_typ = gtype
        @lines = lines
    end



    def reset
        for n in self.nods do
            n.remove
        end
        @nods = []
    end


    def nods=(x)
        self.reset
        n = []
        pos = [] 
        for i in 0...x do
            x =  Node.new(i+1,[], self.graph_typ)

            for c in pos do
                if c[0] and c[1]  then
                    if (x.pos_x == c[0] and x.pos_y == c[1] ) or ((x.pos_x <= c[0]+30 and x.pos_x >= c[0]-30) or (x.pos_y >= c[1]-30 and x.pos_y <= c[1]+30))
                        x.remove
                        x =  Node.new(i+1,[], self.graph_typ)
                    end
                end
            end

            n.append(x)
            pos.append([x.pos_x, x.pos_y])
        end
        @nods = n
    end


    def is_in_graph(x,y)#determina si el mouse esta en alguno de los nodos de grafo

        for i in 0...self.nods.length  do
            if self.nods[i].is_in_node(x,y) then 
                return i#retornamos el index del nodo 
            end
        end
        return -1
    end
end



class Tablero
    attr_reader :w1,:w2,:w3,:w4,:w5,:w6,:w7,:w8,:w9,:w10,:w11,:w12        #varibles para las paredes del tablero
    attr_reader :w13,:w14,:w15, :w16
    attr_reader :relleno1,:relleno2,:relleno3, :relleno4 , :relleno5       #variables para colorear las casillas del tablero
    attr_reader :lock1,:lk1,:lock2,:lk2,:in_txtV  , :in_linestxt           #varibles para controlar los inputs en el tablero 
    attr_reader :graphT,:textGtype,:textDg, :textNg, :title , :conexiontxt #variables para dibujar texto
    attr_reader :nconect1,:nconect2 , :lineconect                          #texto para conexiones entre nodos
    attr_reader :num_nodestxt, :n_nodes, :n_nodestxt,:num_linestxt, :n_lines , :n_linestxt #varibles para texto y para almecenar datos del grafo

    def initialize
        #Paredes del tablero
        @w1 = Line.new(
            x1: 1000, y1:40,
            x2: 1250, y2:40,
            color: 'black', z: 10
        )

        @w2 = Line.new(
            x1: 1000, y1:40,
            x2: 1000, y2:600,
            color: 'black', z: 10
        )

        @w3 = Line.new(
            x1: 1000, y1:600,
            x2: 1250, y2:600,
            color: 'black', z: 10
        )

        @w4 = Line.new(
            x1: 1250, y1:40,
            x2: 1250, y2:600,
            color: 'black', z: 10
        )
        #Pared 1 a 4 son las paredes exteriores
        @w5 = Line.new(
            x1: 1000, y1:70,
            x2: 1250, y2:70,
            color: 'black', z: 10
        )
        #Pared 5 es la linea que esta bajo el titulo

        @w6 = Line.new(
            x1: 1000, y1:150,
            x2: 1250, y2:150,
            color: 'black', z: 10
        )

        @w7 = Line.new(
            x1: 1120, y1:70,
            x2: 1120, y2:150,
            color: 'black', z: 10
        )
        @w8 = Line.new(
            x1: 1120, y1:108,
            x2: 1250, y2:108,
            color: 'black', z: 10
        )

        @w9 = Line.new(
            x1: 1000, y1:190,
            x2: 1250, y2:190,
            color: 'black', z: 10
        )


        @w10 = Line.new(
            x1:1120,y1:150,
            x2:1120,y2: 190,
            color: 'black', z: 10

        )
        @w11 = Line.new(
            x1:1000,y1:230,
            x2:1250,y2: 230,
            color: 'black', z: 10

        )

        @w12 = Line.new(
            x1:1120,y1:190,
            x2:1120,y2: 230,
            color: 'black', z: 10

        )
        #paredes 6-8 para eleccion del tipo de grafica 
        #paredes 9-12 cuadros para numero de vertices y lineas

        @w13 = Line.new(
            x1: 1000, y1: 250,
            x2: 1250, y2: 250, 
            color: 'black' , z: 10
        )
        @w14 =  Line.new(
            x1: 1000, y1: 290,
            x2: 1250, y2: 290, 
            color: 'black' , z: 10
        )

        @w15 = Line.new(
            x1: 1095, y1: 250,
            x2: 1095, y2: 290, 
            color: 'black' , z: 10
        )

        @w16 =  Line.new(
            x1: 1150, y1: 250,
            x2: 1150, y2: 290, 
            color: 'black' , z: 10
        )


        #Figuras para colorear el interior de el tablero
        @relleno1 = Quad.new(
            x1: 1120, y1: 70,
            x2: 1000, y2: 70,
            x3: 1000, y3: 150,
            x4: 1120, y4:150,
            color: 'aqua', z: 10,
            opacity: 0.5 
        )

        #Grafica no dirigida 
        @relleno2 = Quad.new(
            x1: 1250 ,y1: 108,
            x2: 1120, y2: 108,
            x3: 1120, y3: 150,
            x4: 1250, y4:150,
            color: 'green', z: 10,
            opacity: 0.1
        )
        @lock2 = Quad.new(
            x1: 1250 ,y1: 108,
            x2: 1120, y2: 108,
            x3: 1120, y3: 150,
            x4: 1250, y4:150,
            color: 'green', z: 10,
            opacity: 0.1
        )
        @lk2 = false 


        #grafica dirigida
        @relleno3 = Quad.new(
            x1: 1250 ,y1: 70,
            x2: 1120, y2: 70,
            x3: 1120, y3: 108,
            x4: 1250, y4:108,
            color: 'green', z: 10,
            opacity: 0.1 
        )
        @lock1 =  Quad.new(
            x1: 1250 ,y1: 70,
            x2: 1120, y2: 70,
            x3: 1120, y3: 108,
            x4: 1250, y4:108,
            color: 'green', z: 10,
            opacity: 0.1 
        )
        @lk1 = false



        @relleno4 = Quad.new(
            x1:1250, y1:150,
            x2: 1120, y2: 150,
            x3:1120 , y3: 190,
            x4:1250, y4: 190,
            color: 'blue', z: 10,
            opacity: 0.0
        )

        @relleno5 = Quad.new(
            x1:1250, y1:190,
            x2: 1120, y2: 190,
            x3:1120 , y3: 230,
            x4:1250, y4: 230,
            color: 'blue', z: 10,
            opacity: 0.0
        )

        #Textos
        @title = Text.new(
            'Graficas', x: 1100,
            y: 45, size: 16 , color: 'black',
            z: 10
        )

        @textGtype = Text.new(
            'TIPO DE GRAFICA', x:1010,
            y: 100, size: 10, color:'black',
            z: 10
        )

        @textDg = Text.new(
            'Grafica Dirigida', x: 1135,
            y: 82, size: 10, color: 'black',
            z: 10
        )

        @textNg = Text.new(
            'Grafica No Dirigida', x: 1135,
            y: 120, size: 10, color: 'black',
            z: 10
        )

        @num_nodestxt = Text.new(
            'Numero de Vertices',x: 1008,
            y:165, size: 12 , color: 'black',
            z: 10 
        )

        @n_nodes = 0
        @n_nodestxt = Text.new(
            self.n_nodes.to_s, x: 1125,
            y: 165, size: 10, color: 'black',
            z: 10 
        )


        @n_lines = 0
        @n_linestxt = Text.new(
            self.n_lines.to_s,x: 1125,
            y:205, size: 12 , color: 'black',
            z: 10 
        )

        @num_linestxt = Text.new(
            'Numero de Lineas',x: 1008,
            y:205, size: 12 , color: 'black',
            z: 10 
        )


        @conexiontxt = Text.new(
            'Conexiones', x: 1095,
            y: 232, size: 12, color: 'black',
            z: 10
        )

        @nconect1 = Text.new(
            'vertice A', x: 1010,
            y: 270, size: 15, color: 'black',
            z: 10
        )


        @nconect2 = Text.new(
            'vertice B', x: 1160,
            y: 270, size: 15, color: 'black',
            z: 10
        )
        
        @lineconect = Text.new(
            '----', x: 1105, y: 260,
            size: 15, color: 'black', z: 10
        )


        @in_txtV = true
        @in_linestxt = true



    end

    def lk1=(x)
        @lk1 = x
    end

    def lk2=(x)
        @lk2 = x
    end


    def in_txtV=(x)
        @in_txtV = x
    end


    def in_linestxt=(x)
        @in_linestxt = x
    end

    def n_nodes=(x)
        @n_nodes = x
    end

    def n_lines=(x)
        @n_lines = x
    end
end


#saber si el mouse se encuentra en el cuadro de grafica dirigida
is_in_dg = lambda do |x,y|
    if x >= 1120 and x <= 1250 and y >= 70 and y <= 108 then 
        true
    else
        false
    end
end

#saber si el mouse se encuentra en el cuadro de grafica no dirigida
is_in_ng= lambda do |x,y|
    if x >= 1120 and x <= 1250 and y > 108 and y < 150 then 
        true
    else
        false
    end

end

#saber si el mouse se encuentra en cuadro de numero de vertices
is_in_Nvertex = lambda do|x,y| 
    if x >= 1120 and x <= 1250 and y >= 150 and y < 190 then
        true
    else 
        false
    end
end

#saber si el mouse se encuentra en el cuadro de lineas
is_in_NLines = lambda do|x,y| 
    if x >= 1120 and x <= 1250 and y > 190 and y <= 230 then
        true
    else 
        false
    end
end


is_in_vertexA = lambda do |x, y|
    if x >= 1000 and x <= 1095 and y >= 250 and y <= 290
        true
    else
        false
    end
end

is_in_vertexB = lambda do |x, y|
    if x >= 1150 and x <= 1250 and y >= 250 and y <= 290
        true
    else
        false
    end
end

tab = Tablero.new
g = Graph.new(0,0,'ng')
current_vertex = -1
vertex_b = -1


on :mouse_move do |event|

    if is_in_dg.call event.x, event.y then
        tab.relleno3.opacity = 0.5
    else
        tab.relleno3.opacity = 0.1
    end

    if is_in_ng.call event.x, event.y then
        tab.relleno2.opacity = 0.5
    else
        tab.relleno2.opacity = 0.1
    end



    if is_in_Nvertex.call event.x, event.y then
        tab.relleno4.opacity = 0.2
    else
        tab.relleno4.opacity = 0.0
    end


    if is_in_NLines.call event.x, event.y then
        tab.relleno5.opacity = 0.2
    else
        tab.relleno5.opacity = 0.0
    end
    
end

on :mouse_down do |event|

    case event.button
    when :left 
        if is_in_dg.call event.x, event.y then
            tab.lock2.opacity = 0.1
            tab.lk2 = false
            tab.lock1.opacity = 0.8
            tab.lk1 = true
            tab.lineconect.text = '--->'
        end

        if is_in_ng.call event.x, event.y then
            tab.lock1.opacity = 0.1
            tab.lk1 = false
            tab.lock2.opacity = 0.8
            tab.lk2 = true
            tab.lineconect.text = '<-->'
        end


        if is_in_Nvertex.call event.x , event.y then 
            tab.in_txtV = true 
            tab.in_linestxt = false
            #tab.relleno4.opacity = 0.8
            #tab.relleno5.opacity = 0.0
        end

        if is_in_NLines.call  event.x, event.y then 
            tab.in_linestxt = true
            tab.in_txtV = false 
            #tab.relleno5.opacity = 0.8
            #tab.relleno4.opacity = 0.0
        end

        if g.is_in_graph(event.x, event.y)  != -1 then
            aux = g.is_in_graph(event.x,event.y)
            current_vertex = aux 
            g.nods[aux].move(event.x,event.y)
        end


        if current_vertex != -1 and event.x < 950
            g.nods[current_vertex].move(event.x, event.y)
        end

        
    when :right
        
    end
end




#Saber si la tecla presionada es un numero
def is_keypad(s)
    case s
    when 'keypad 0'
        0
    when 'keypad 1'
        1
    when 'keypad 2'
        2
    when 'keypad 3'
        3
    when 'keypad 4'
        4
    when 'keypad 5'
        5
    when 'keypad 6'
        6
    when 'keypad 7'
        7
    when 'keypad 8'
        8
    when 'keypad 9'
        9
    when '1'
        1
    when '2'
        2
    when '3'
        3
    when '4'
        4
    when '5'
        5
    when '6'
        6
    when '7'
        7
    when '8'
        8
    when '9'
        9
    when '0'
        0
    else
        -1
    end
end




on :key_down do |event|
    #tab.n_nodes += event.key.to_s
    #Si la tecla presionada es un numero  

    if event.key != 'backspace' and is_keypad(event.key) != -1 then
    
        if tab.in_txtV == true and  tab.n_nodestxt.text.length < 10 
            x = is_keypad(event.key)
            tab.n_nodestxt.text += x.to_s
        end

        if tab.n_linestxt.text.length < 10 and tab.in_linestxt  == true
            l = is_keypad(event.key)
            tab.n_linestxt.text += l.to_s
        end
    
    
    end


    if event.key == 'n'
        #s = Window.new( height: 240, width: 300,title: 'prueba') 
        #show
    end
    

    if event.key == 'backspace' and tab.in_txtV
        tab.n_nodestxt.text = tab.n_nodestxt.text.chop
    elsif  event.key == 'backspace' and tab.in_linestxt
        tab.n_linestxt.text = tab.n_linestxt.text.chop
    end

    if event.key == 'return' and tab.in_txtV
        tab.n_nodes = tab.n_nodestxt.text.to_i
        g.nods = tab.n_nodes
    elsif event.key == 'return' and tab.in_linestxt
        tab.n_lines = tab.n_lines.to_i
    end
end
show