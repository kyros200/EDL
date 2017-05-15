function love.load()
    platform={}
    player={}

    --Setor Plataforma Simples
    platform.x = 0
    platform.y = love.graphics.getHeight() / 1.25
    platform.width=love.graphics.getWidth()
    platform.heigth=love.graphics.getHeight()

    --Setor Player
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 1.25
    player.img = love.graphics.newImage('blob.png')
    player.speed = 400
    player.ground = love.graphics.getHeight() / 1.25
    player.velocidadeY = 0
    player.jumpHeight = -500    
    player.gravity = -500        
    
    --Setor que define os numeros que serao mostrados na tela
    tempo = 0 --Instances. Uma core nasce a cada x stances, e vai diminuindo ao longo do tempo
    pontuacao = 0 --Quantas Cores pegas em jogo
    circulos = {} --Cores em jogo
    quantCirc = 0

    --Setor para definir a cor do fundo da tela.
    fundo = 0 --Quanto maior o fundo, mais vermelho é o fundo
    count = 0 --A cada 10 count, fundo aumenta o valor

    --Setor outros
    love.graphics.setFont(love.graphics.newFont(30)) -- Tamanho da fonte sempre sera 30
    love.graphics.setBackgroundColor(fundo,0,0)
    texto = "Pegue as Cores na tela. Você perde ao ter 10 Cores ao mesmo tempo."
    textoPont = "Pontuação: "
    freq = 150

    fimDeJogo = 0
end

function love.update(dt)

    tempo = tempo + 1
    if tempo >= freq then
        quantCirc = quantCirc + 1
        if quantCirc == 10 then
            fimDeJogo = 1
            texto = "Você deixou as Cores te dominarem. Aperte R para reniciar o jogo."
            freq = 3
        end
        table.insert(circulos,{x = math.random(0, love.graphics.getWidth() - 20), y = math.random(250, 400), raio = math.random(7,15)})
        tempo = 0
    end
   
    if player.velocidadeY ~= 0 then                                  
        player.y = player.y + player.velocidadeY * dt                
        player.velocidadeY = player.velocidadeY - player.gravity * dt
    end

    if player.y > player.ground then    
        player.velocidadeY = 0       
        player.y = player.ground
    end

    if love.keyboard.isDown('r') then
        love.load()
    end

    if fimDeJogo == 0 then
        if love.keyboard.isDown('d') or love.keyboard.isDown('right') then

            if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
                player.x = player.x + (player.speed * dt)
            end
      
        elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then            
                
            if player.x > 0 then 
                player.x = player.x - (player.speed * dt)
            end
        end

        if love.keyboard.isDown('w') or love.keyboard.isDown('up') then

            if player.velocidadeY == 0 then
                player.velocidadeY = player.jumpHeight
            end
        end
     
        for index,v in ipairs(circulos) do 

            if collides (v) then
                table.remove(circulos,index)

                quantCirc = quantCirc - 1
                pontuacao = pontuacao + 1
                verTexto(pontuacao)

                count = count + 1
                if count >= 2 then
                    count = 0
                    fundo = fundo + 1
                    love.graphics.setBackgroundColor(fundo,0,0)
                end
            end
        end
    end
end

function love.draw()
    love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.heigth)
    love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 32)

    love.graphics.setColor(fundo,0,0,255)
    love.graphics.print(textoPont..pontuacao,0,platform.y)
    if(fimDeJogo == 0) then
        love.graphics.print("Cores em Jogo: "..quantCirc, 0, platform.y + 30)
        love.graphics.print("Frequência: "..freq, 0, platform.y + 60)
    end

    love.graphics.setColor(255,math.random(50, 255),math.random(50, 255),255)
    love.graphics.print("C  O  R  E  S", (love.graphics.getWidth() / 2) - 100 , 0)

    love.graphics.setColor(255,255,255,255)
    love.graphics.printf(texto, (love.graphics.getWidth() / 2) - 250, 30, 500, "center")

    for index,v in ipairs(circulos) do 
        love.graphics.setColor(math.random(50, 255),math.random(50, 255),math.random(50, 255),255)
        love.graphics.circle('fill', v.x, v.y, v.raio)  
        love.graphics.setColor(255,255,255,255)
    end
    love.graphics.setColor(255,255,255,255)
end

function collides (v)

    return (player.x+32 >= v.x - v.raio) and (player.x <= v.x+v.raio) and
           (player.y+32 >= v.y - v.raio) and (player.y <= v.y+v.raio)

end

function verTexto(p)
    if(p>=3) then
        texto = ""
    end
    if(p>=5) then
        texto = "Cor: Impressão produzida no olho pela luz. Plural: Cores"
        freq = 140
    end
    if(p>=8) then
        texto = ""
    end
    if(p>=10) then
        texto = "Core [kohr]: The central, innermost, or most essential part of anything. Plural: Cores"
        freq = 130
    end
    if(p>=15) then
        texto = ""
    end
    if(p>=20) then
        texto = "Você está ótimo. Continue assim. Vamos agilizar mais."
        freq = 110
    end
    if(p>=23) then
        texto = ""
    end
    if(p>=30) then
        texto = "Mais Rápido."
        freq = 100
    end
    if(p>=34) then
        texto = ""
    end
    if(p>=40) then
        texto = "Está vindo duas vezes mais rápido do que o começo. Boa sorte"
        freq = 75
    end
    if(p>=43) then
        texto = ""
    end
    if(p>=50) then
        texto = "O fundo...está mudando..."
    end
    if(p>=56) then
        texto = ""
        freq = 60
    end
    if(p>=65) then
        texto = "Sim, está mudando. Para Vermelho."
        freq = 50
    end
    if(p>=75) then
        texto = ""
        freq = 50
    end
    if(p>=100) then
        texto = "Pontuação em Inglês? Score."
        textoPont = "Score: "
    end
    if(p>=115) then
        texto = "Score = A parte essecial desse jogo."
    end
    if(p>=130) then
        texto = "Score = coreS"
    end
    if(p>=138) then
        texto = ""
        freq = 40
    end
    if(p>=170) then
        texto = "Cinco vezes mais rápido do que o começo. Você ganha com 500 pontos"
        freq = 30
    end
    if(p>=230) then
        texto = ""
    end
    if(p>=250) then
        texto = "Metade do Caminho."
    end
    if(p>=260) then
        texto = ""
        freq = 25
    end
    if(p>=500) then
        texto = "O fundo está totalmente vermelho. Considere-se vitorioso, mas não pare. O essencial ainda continua necessário para você. Essa é a vida."
        freq = 20
    end
    if(p>=1000) then
        texto = "1000 Cores. Ok, você venceu duas vezes. Chega né?"
    end
end