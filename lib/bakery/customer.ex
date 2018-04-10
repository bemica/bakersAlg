defmodule Customer do
  def take_ticket(customer_num) do
    receive do
      {:ticket} ->
        IO.puts("Customer #{customer_num} got ticket number #{num}")
        waitForServer(customer_num)
      {:finish} ->
        exit(:normal)
    end
  end

  def waitForServer(customer_num) do
    receive do
      {:serve, server_num, manager} ->
        IO.puts("Customer #{customer_num} is now being served by #{server_num}")
        askForTicket(customer_num, manager)
      {:finish} ->
        exit(:normal)
    end
  end

  def askForTicket(customer_num, manager) do
    sleep_time = :rand.uniform(1000)
    :timer.sleep(sleep_time)
    send(manager, {:request_ticket, customer_num}
    take_ticket(customer_num)
  end
end
