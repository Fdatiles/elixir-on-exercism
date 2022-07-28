defmodule Newsletter do
  @spec read_emails(String.t()) :: [String.t()]
  def read_emails(path),
    do: path |> File.stream!() |> Enum.map(&String.trim/1)

  @spec open_log(String.t()) :: pid
  def open_log(path), do: File.open!(path, [:write])

  @spec log_sent_email(pid, :ok) :: :ok
  def log_sent_email(pid, email), do: IO.puts(pid, email)

  @spec close_log(pid) :: :ok | {:error, atom}
  def close_log(pid), do: File.close(pid)

  @spec send_newsletter(String.t(), String.t(), (String.t() -> any)) :: :ok
  def send_newsletter(emails_path, log_path, send_fun) do
    log_file = open_log(log_path)

    emails_path
    |> read_emails()
    |> Enum.each(fn email -> if send_fun.(email) == :ok, do: log_sent_email(log_file, email) end)

    close_log(log_file)
  end
end
