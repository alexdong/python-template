from fasthtml.common import (
    H1,
    Body,
    Div,
    FastHTML,
    Head,
    Html,
    Link,
    Meta,
    P,
    Title,
)
import uvicorn

app = FastHTML(hdrs=(Link(rel="stylesheet", href="https://cdn.tailwindcss.com"),))


@app.get("/")  # type: ignore
def home():  # type: ignore  # noqa: ANN201
    return Html(
        Head(
            Title("Hello World - FastHTML with Tailwind"),
            Meta(charset="utf-8"),
            Meta(name="viewport", content="width=device-width, initial-scale=1"),
        ),
        Body(
            Div(
                H1("Hello World!", cls="text-4xl font-bold text-blue-600 text-center"),
                P(
                    "This is a FastHTML application with Tailwind CSS configured.",
                    cls="text-lg text-gray-700 text-center mt-4",
                ),
                cls="min-h-screen flex flex-col items-center justify-center bg-gray-100",
            )
        ),
    )


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5001)
