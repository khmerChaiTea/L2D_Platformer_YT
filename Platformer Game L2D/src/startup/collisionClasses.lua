function createCollisionClasses()
    function beginContact(a, b, collision)
        -- order matters: coin/spike may consume the contact
        if coin.beginContact(a, b, collision) then return end
        if spike.beginContact(a, b, collision) then return end

        -- enemy and player both get the raw fixtures
        enemy.beginContact(a, b, collision)
        player:beginContact(a, b, collision)
    end

    function endContact(a, b, collision)
        player:endContact(a, b, collision)
    end
end
