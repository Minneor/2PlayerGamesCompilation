-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local M = {}

M.events = {}

function M.add_new_event(event_name)
    local event = {}
    event.name = event_name
    event.subscribers = {}
    M.events[""..event_name] = event
end

function M.subscribe_to_event(event_name, path_subscriber)
    local subscribers = M.events[""..event_name].subscribers
    table.insert(subscribers, #subscribers+1, path_subscriber)
end

function M.unsubscribe_event(event_name, path_subscriber )
    if #M.events[""..event_name].subscribers == 0 then
        return false
    end  
    local subscribers = M.events[""..event_name].subscribers
	for i=1, #subscribers, 1 do
        if subscribers[i] == path_subscriber then
            table.remove(subscribers, i)
        end
    end
    return true
end

function M.push_event(event_name, data_table)
    --print(#M.events[""..event_name].subscribers)
    if #M.events[""..event_name].subscribers == 0 then
        return false
    end  
    local subscribers = M.events[""..event_name].subscribers
    print("Subscribers: "..subscribers[1])
    for i = 1, #subscribers, 1 do
        msg.post(""..subscribers[i], event_name, data_table or {})
    end
    return true
end

function M.reset_events()
    M.events = {}
end

function M.print_events()
    pprint(M.events)
end

return M
