defmodule Server do
  def is_free() do
    receive do
      {:request, customer, manager} ->
        serving(customer, manager)
      {:finish} ->
        exit(:normal)
    end
  end

  def serving(customer, manager) do
  #  IO.puts("Now serving a customer")
    n = :rand.uniform(40)
    fibn = fib(n)
  #IO.puts("computed fib of #{n} to be #{fibn}")
    send(customer, {:serve, self(), manager, n, fibn})
    send(manager, {:free, self()})
    is_free()
  end

  defp fib(0), do: 0
  defp fib(1), do: 1
  defp fib(n), do: fib(n-2) + fib(n-1)
end
