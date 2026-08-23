-- Src/Elements/Button/Method.lua
return function(ButtonObject, ButtonFrame, TitleLabel, WindowObject)
    
    function ButtonObject.SetTitle(newTitle)
        ButtonObject.Title = tostring(newTitle)
        TitleLabel.Text = ButtonObject.Title
    end

    function ButtonObject.Destroy()
        ButtonFrame:Destroy()
        
        -- Dọn dẹp TitleLabel khỏi danh sách TextElements của Window
        local textIdx = table.find(WindowObject.TextElements, TitleLabel)
        if textIdx then
            table.remove(WindowObject.TextElements, textIdx)
        end
    end

end

