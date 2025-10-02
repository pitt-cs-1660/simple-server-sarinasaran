# =========================
# Build Stage
# =========================
FROM python:3.12 AS build

RUN pip install uv
WORKDIR /simple-server-sarinasaran
COPY pyproject.toml uv.lock* ./
RUN uv venv .venv
RUN uv pip compile pyproject.toml --quiet > requirements.txt
RUN uv pip install --prefix .venv -r requirements.txt

# =========================
# Final Stage
# =========================
FROM python:3.12-slim AS final
WORKDIR /simple-server-sarinasaran
COPY --from=build /simple-server-sarinasaran/.venv .venv
COPY . .
RUN chmod 777 /simple-server-sarinasaran
RUN useradd -m user
USER user
EXPOSE 8000
ENV PATH="/simple-server-sarinasaran/.venv/bin:$PATH"
ENV PYTHONPATH=/simple-server-sarinasaran
CMD ["uvicorn", "cc_simple_server.server:app", "--host", "0.0.0.0", "--port", "8000"]

