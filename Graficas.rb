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
    attr_reader :fig 
    def initialize(id,ady,gtype)
        colors = ['black', 'green', 'blue', 'navy', 'lime', 'aqua',
        'olive', 'yellow', 'orange', 'red', 'brown', 'fuchsia', 'purple',
        'maroon', 'gray']
        @ady = ady 
        @graph_type = gtype 

        @fig = Circle.new(
            x:rand(800)+11 , y: rand(650)+30,
            radius: 30, sectors: 6,
            color: colors[rand(colors.length)],
            z: 10
        )


        @id = Text.new(
            id.to_s,x: self.fig.x-5 ,
            y: self.fig.y-6, color: 'white',
            size: 15, z: 10
        )


    end

    def pos_x
        return self.fig.x
    end

    def pos_y
        return self.fig.y
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





class Tablero
    attr_reader :w1,:w2,:w3,:w4,:w5,:w6,:w7,:w8,:w9,:w10
    attr_reader :relleno1,:relleno2,:relleno3
    attr_reader :lock1,:lk1,:lock2,:lk2
    attr_reader :graphT,:textGtype,:textDg, :textNg, :title
    attr_reader :num_nodestxt, :n_nodes, :n_nodestxt

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
        #paredes 6-8 para eleccion del tipo de grafica 


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

        @n_nodes = ''
        @n_nodestxt = Text.new(
            self.n_nodes.to_s, x: 1125,
            y: 165, size: 10, color: 'black',
            z: 10 
        )



    end

    def lk1=(x)
        @lk1
    end

    def lk2=(x)
        @lk2
    end

    def n_nodes=(x)
        @n_nodes
    end
end


#saber si el mouse se encuentra en el cuadro de grafica dirigida
is_in_dg= lambda do |x,y|
    if x >= 1120 and x <= 1250 and y >= 70 and y <= 108 then 
        true
    else
        false
    end

end

#saber si el mouse se encuentra en el cuadro de grafica no dirigida
is_in_ng= lambda do |x,y|
    if x >= 1120 and x <= 1250 and y >= 108 and y <= 150 then 
        true
    else
        false
    end

end


tab = Tablero.new
n1 = Node.new(10, [1,2, 8], 'dg')
n2 = Node.new(8,[10,4],'dg')

#l1 = LinesD.new(n1,n2)



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
    
end

on :mouse_down do |event|

    case event.button
    when :left 
        if is_in_dg.call event.x, event.y then
            tab.lock2.opacity = 0.1
            tab.lk2 = false
            tab.lock1.opacity = 0.8
            tab.lk1 = true
        end

        if is_in_ng.call event.x, event.y then
                tab.lock1.opacity = 0.1
                tab.lk1 = false
                tab.lock2.opacity = 0.8
                tab.lk2 = true
        end


        
    when :right
        
    end
end


on :key_down do |event|
    #tab.n_nodes += event.key.to_s
    if  event.key != 'backspace'
        tab.n_nodestxt.text += event.key
    else
        tab.n_nodestxt.text = tab.n_nodestxt.text.chop
    end
end
show