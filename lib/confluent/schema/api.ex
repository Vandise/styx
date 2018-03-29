defmodule Styx.Confluent.Schema.API do

  @content_type "application/vnd.schemaregistry.v1+json"

  @moduledoc """
  API wrapper for the Confluent Schema Registry
  Available methods:
    * config/1
    * subjects/1
    * versions/2
    * version/3
    * latest/2
    * schema/2
    * delete/2
    * delete/3
    * register/3
    * check/3
    * test/4
    * update_compatibility/2
    * update_compatibility/3
  """

  @doc """
  Get top level config.
  ```
    Styx.Confluent.Schema.API.config("http://localhost:8081")
  ```
  """

  def config(host), do: request(:get, host, "config")

  @doc """
  List all subjects.
  ```
    Styx.Confluent.Schema.API.subjects("http://localhost:8081")
  ```
  """
  def subjects(host), do: request(:get, host, "subjects")

  @doc """
  List all schema versions registered under the subject "value"
  ```
    Styx.Confluent.Schema.API.versions("http://localhost:8081", "value")
  ```
  """
  def versions(host, subject), do: request(:get, host, "subjects/#{subject}/versions")

  @doc """
  Fetch version 1 of the schema registered under subject "value"
  ```
    Styx.Confluent.Schema.API.version("http://localhost:8081", "value", 1)
  ```
  """
  def version(host, subject, version), do: request(:get, host, "subjects/#{subject}/versions/#{version}")

  @doc """
  Fetch latest version of the schema registered under subject "value"
  ```
    Styx.Confluent.Schema.API.latest("http://localhost:8081", "value")
  ```
  """
  def latest(host, subject), do: version(host, subject, "latest")

  @doc """
  Fetch a schema by globally unique id 1
  ```
    Styx.Confluent.Schema.API.schema("http://localhost:8081", 1)
  ```
  """
  def schema(host, id), do: request(:get, host, "schemas/ids/#{id}")

  @doc """
  Delete all versions of the schema registered under subject "value"
  ```
    Styx.Confluent.Schema.API.delete("http://localhost:8081", "value")
  ```
  """
  def delete(host, subject), do: request(:delete, host, "subjects/#{subject}")

  @doc """
  Delete version 1 of the schema registered under subject "value"
  ```
    Styx.Confluent.Schema.API.delete("http://localhost:8081", "value", 1)
  ```
  """
  def delete(host, subject, version), do: request(:delete, host, "subjects/#{subject}/versions/#{version}")

  @doc """
  Register a new version of a schema under the subject "Kafka-key"
  ```
    Styx.Confluent.Schema.API.register("http://localhost:8081", "value", %{"type" => "string"})
  ```
  """
  def register(host, subject, schema), do: request(:post, host, "subjects/#{subject}/versions", schema)

  @doc """
  Check whether a schema has been registered under subject "value"
  ```
    Styx.Confluent.Schema.API.check("http://localhost:8081", "value", %{"type" => "string"})
  ```
  """
  def check(host, subject, schema), do: request(:post, host, "subjects/#{subject}", schema)

  @doc """
  Test compatibility of a schema with specific version of schema under subject "value"
  ```
    Styx.Confluent.Schema.API.test("http://localhost:8081", "value", %{"type" => "string"})
  ```
  """
  def test(host, subject, schema, version \\ "latest"), do: request(:post, host, "compatibility/subjects/#{subject}/versions/#{version}", schema)

  @doc """
  Update compatibility requirements globally
  ```
    Styx.Confluent.Schema.API.update_compatibility("http://localhost:8081", "NONE")
  ```
  """
  def update_compatibility(host, comp), do: request(:put, host, "config", comp)

  @doc """
  Update compatibility requirements under the subject "value"
  ```
    Styx.Confluent.Schema.API.update_compatibility("http://localhost:8081", "value", "NONE")
  ```
  """
  def update_compatibility(host, subject, comp), do: request(:put, host, "config/#{subject}", comp)


  #
  # Private
  #

  defp request(method, host, path) when method == :get or method == :delete do
    case apply(HTTPoison, method, ["#{host}/#{path}"]) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Poison.decode! body}

      {_, %HTTPoison.Response{body: body}} ->
        {:error, Poison.decode! body }

      error ->
        error

    end
  end

  defp request(method, host, path, content) when is_binary(content) do
    body = Poison.encode! %{"compatibility" => content}

    case apply(HTTPoison, method, ["#{host}/#{path}", body, [{"Content-Type", @content_type}]]) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Poison.decode! body}

      {_, %HTTPoison.Response{body: body}} ->
        {:error, Poison.decode! body }

      error ->
        error

    end
  end

  defp request(method, host, path, content) do
    body = Poison.encode! %{"schema" => Poison.encode!(content)}

    case apply(HTTPoison, method, ["#{host}/#{path}", body, [{"Content-Type", @content_type}]]) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Poison.decode! body}

      {_, %HTTPoison.Response{body: body}} ->
        {:error, Poison.decode! body }

      error ->
        error

    end
  end

end