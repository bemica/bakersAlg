defmodule Manager do
  def open_store(num_customers, num_servers) do
    customers = (1..num_customers) |> Enum.map(fn(n) -> spawn(Customer, :askForTicket, [self()]) end)
    servers = (1..num_servers) |> Enum.map(fn(n) -> spawn(Server, :is_free, []) end)
    {customers, servers}
  end

  def create_customer() do
    customer = spawn(Customer, :askForTicket, [self()])
    customer
  end

  def serve(customers, servers) do
    waiting_customers = Enum.count(customers)
    free_servers = Enum.count(servers)
    IO.puts("There are #{waiting_customers} customers waiting to be served by #{free_servers} free servers")
    receive do
      {:request_ticket, customer} ->
        if List.first(servers) == nil do
          serve(customers ++ [customer], servers)
        else
          server = List.first(servers)
          send(customer, {:ticket})
          send(server, {:request, customer, self()})
          serve(customers, List.delete(servers, server))
        end
      {:free, server} ->
        if List.first(customers) == nil do
          serve(customers, servers ++ [server])
        else
          customer = List.first(customers)
          send(customer, {:ticket})
          send(server, {:request, customer, self()})
          serve(List.delete(customers, customer), servers)
        end
    end
  end
end
