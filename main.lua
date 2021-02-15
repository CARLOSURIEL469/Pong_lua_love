

--se usan otros archivos como clas para poder implementar clases como las conocemos en lua.y poder implementar otras funciones 
push=require 'push'

--FUNCIONES A LLAMAR 
Class = require 'class'
require 'Paddle'
require 'Ball'



WINDOW_WIDTH=1280
WINDOW_HEIGTH=720

VIRTUAL_WIDTH=432
VIRTUAL_HEIGTH=243

PADDLE_SPEED=200

--esta variable estupila el limite de puntuacion del juego 

LIMIT_SCORE=5

---CARGA LOS ELEMENTOS QUE SE VAN A USAR 

function love.load()
	 love.graphics.getDefaultFilter('nearest','nearest')

	 math.randomseed(os.time())
	 smallFont= love.graphics.newFont('font.ttf', 8)
	 scoreFont= love.graphics.newFont('font.ttf', 32)

	 blue=love.graphics.setColor(0,0,1,1)

	 love.graphics.setFont(smallFont)

	 --efectos de sonido incluidos 
	 paddle_collide=love.audio.newSource("ping3.mp3", "static")

	 border_collide=love.audio.newSource("mario-bros-ooh.mp3", "static")
	 inicio_juego=love.audio.newSource("bomberman-start.mp3", "static")
	 winning_song=love.audio.newSource("bites-ta-da-winner.mp3", "static")
	 point_sound=love.audio.newSource("mario-bros vida.mp3", "stream")

	 --PARTIDAS GANADAS , EN CASO DE QUERER HACER UN CONTEO 
	 JUGADOR1_P=0
	 JUGADOR2_P=0

	 ---para crear la pantalla deacuerdo a las especificaciones de los tamaños 
	 push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGTH,WINDOW_WIDTH,WINDOW_HEIGTH,{
	 	fullscreen=false,
	 	resizable=false,
	 	vsync=true

	 })
--varibles relacionedas al jugador 1 y 2
--decidi cambir el tamaño por unos paddle mas largos 
	 player1=Paddle(10,100,6,35)
	 player2=Paddle(VIRTUAL_WIDTH-10,VIRTUAL_HEIGTH-50,6,35)

 --variables de las pelotas 
---asigna un movimiento aleatorio a la pelora para que no sea predecible y debe empezar de una semilla o valor para tenerlo por default 
--por eso se ocupa una semilla en base de una fecha 
 	ball=Ball(VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGTH/2-2,4,4)

--marcador de ambos jugadores 
	 player1Score=0
	 player2Score=0


--varibale para el estado del juego 
	 gameState='start'


end

--UPDATE SIRVE PARA MANTER EL JUEGO EN UNA CONSTANTE ACTUALIZACION 
function love.update(dt)


--esta funcion sirve para indicar el comportamiento de la pelota a la hora de chocar con un borde de la pantalla superior o inferior 
	if gameState=='play' then 

		if ball.y<=0 then 
			--sonido de colicion
			border_collide:play()
			ball.y=0
			ball.dy=-ball.dy
		end

		if ball.y>=VIRTUAL_HEIGTH-4 then 
			--sonido de colicion 
			border_collide:play()
			ball.y=VIRTUAL_HEIGTH-4
			ball.dy=-ball.dy
		end



---REBOTE PRESENTE AL TOCAR UN PDDLE CON LA PELOTE POR PARTE DE UN JUGADOR 
		--PARA EL JUGADOR UNO 
		if ball:collides(player1) then
			paddle_collide:play()
			---le cambien la velocidad para hacerlo mas divertido
			ball.dx=-ball.dx*1.02
			ball.x=player1.x+5

			if ball.dy<0 then 
				ball.dy=-math.random(10,150)
			else
				ball.dy=math.random(10,150)
			end
		end
		--PARA  EL JUGADOR 2
		if ball:collides(player2) then
			paddle_collide:play()
			ball.dx=-ball.dx* 2
			ball.x=player2.x-4

			if ball.dy<0 then 
				ball.dy=-math.random(10,150)
			else
				ball.dy=math.random(10,150)
			end
		end
	end


	--en caso de anotar el jugaror 2, su score se actualiza y reinicia la posicion de la pelota 
	--esto cuando la pelota toca el borde del jugador contrario
	if ball.x<0 then 
		--el sonido al anotar un punto
		
		player2Score=player2Score+1

		if player2Score==LIMIT_SCORE then
			--CANCION DE VICTORIA
			winning_song:play()
			ball:reset()
			gameState='win'
			--marcador de partidos ganados 
			JUGADOR2_P=JUGADOR2_P+1
				
		else
			point_sound:play()
			ball:reset()
			gameState='start'
		end
	end

--en caso de anotar el jugaror 2, su score se actualiza y reicinia la posicion de la pelota 
--esto cuando la pelota toca el borde del jugador contrario
	if ball.x > VIRTUAL_WIDTH then 
		--el sonido al anotar un punto
		player1Score=player1Score+1
		if player1Score==LIMIT_SCORE then
			--CANCION DE VICTORIA
			winning_song:play()
			ball:reset()
			gameState='win'

			--marcador de partidos ganados 
			JUGADOR1_P=JUGADOR1_P+1
		else
			point_sound:play()
			ball:reset()
			gameState='start'
		end
	end


----------------------------------------------------------------------------------------------------

		----movimiento del paddle del jugador1 
	if love.keyboard.isDown('w') then
		player1.dy=-PADDLE_SPEED

	elseif love.keyboard.isDown('s') then 
		player1.dy=PADDLE_SPEED

	else
		player1.dy=0
	end


	---movimiento del jugador 2, ambas de manera independiente 
	if love.keyboard.isDown('up') then
		player2.dy=-PADDLE_SPEED

	elseif love.keyboard.isDown('down') then 
		player2.dy=PADDLE_SPEED

	else
		player2.dy=0
	end

--funcion para el movimiento de la pelota de manera aleatoria 
	if gameState=='play'then 
		ball:update(dt)
	end

	player1:update(dt)
	player2:update(dt)
end



--funciones en caso de que el jugador llegue a precionar alguna tecla 
function love.keypressed(key)
	-- body

	--definir el estado deacuerdo a las teclas introducidas 
		if key=='escape' then 
			love.event.quit()
		elseif key=='enter' or key=='return' then 
			if gameState=='start' then 
				
				gameState='play'
				---agrege un nuevo estado en caso de que uno de los dos gane 
			elseif gameState=='win' then
				gameState='start'
				ball.reset(ball)
				player1Score=0
	    		player2Score=0

			else
				gameState='start'
				inicio_juego:play()
				--regresa la pelota al estado base una vez se reinicie el juego 
				--corregui el error, ahora es posible reiniciar el juego, debido a que antes solo aparecia un error 
				ball.reset(ball)
				player1Score=0
	    		player2Score=0

			end
		end
end


function love.draw()
	push:apply("start")
	--push:apply("win")
	---metodo para describir el estado del juego , en caso de que se este jugando o no 


	--FUNCIONES PARA INDICAR EL NUMERO DE PARTIDAS GANADAS QUE LLEVA CADA JUGADOR 
	love.graphics.setFont(smallFont)
	love.graphics.printf('PLAYER1',-190,5,VIRTUAL_WIDTH,'center')
	love.graphics.printf('PLAYER2',190,5,VIRTUAL_WIDTH,'center')
	love.graphics.printf(tostring(JUGADOR1_P),-190,13,VIRTUAL_WIDTH,'center')
	love.graphics.printf(tostring(JUGADOR2_P),190,13,VIRTUAL_WIDTH,'center')
	--nuevo estado win en caso de que uno de los dos gane, y pueda mostra el mensaje correspondiente 
	--le ingrese un codigo de color para la presentacion 
	love.graphics.setColor(0,255,0)
	if gameState=='win' and player1Score==LIMIT_SCORE then 
			love.graphics.setColor(139,0,139)
			love.graphics.printf('GANADOR, JUGADOR 1',0,60,VIRTUAL_WIDTH,'center')

		
	elseif  gameState=='win' and player2Score==LIMIT_SCORE then 
			love.graphics.setColor(139,0,139)
			love.graphics.printf('GANADOR, JUGADOR 2',0,60,VIRTUAL_WIDTH,'center')
			
	elseif gameState=='start'  then 

		love.graphics.printf('LISTOS!',0,20,VIRTUAL_WIDTH,'center')
	else
		love.graphics.printf('A JUGAR !',0,20,VIRTUAL_WIDTH,'center')
	end

	love.graphics.setFont(scoreFont)
	--en donde coloca el icono que marca los puntos de los jugadores 
	--yo puse colores por que se me hacia muy simple todo 
	love.graphics.setColor(255,0,0)
	love.graphics.print(tostring(player1Score),VIRTUAL_WIDTH/2-50,VIRTUAL_HEIGTH/3)
	love.graphics.setColor(0,0,255)
	love.graphics.print(tostring(player2Score),VIRTUAL_WIDTH/2+30,VIRTUAL_HEIGTH/3)
	love.graphics.setColor(255,0,0)
	player1:render()
	love.graphics.setColor(0,0,255)
	player2:render()

	love.graphics.setColor(255,0,255)
	ball:render()
	push:apply("end")
end