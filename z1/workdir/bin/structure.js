[
  {
    "Node": "text",
    "Children": "\n\n\n\n"
  },
  {
    "Node": "dependencies",
    "Children": [
      {
        "Node": "text",
        "Children": "\n    RUN apt-get install j\n    RUN pip install numpy\n"
      }
    ]
  },
  {
    "Node": "text",
    "Children": "\n\n\n"
  },
  {
    "Node": "erlang",
    "Children": [
      {
        "Node": "text",
        "Children": "\n\nmain(Args) ->\n    "
      },
      {
        "Node": "python",
        "Children": [
          {
            "Node": "text",
            "Children": "\n        import numpy as np\n\n        a = np.array("
          },
          {
            "Node": "j",
            "Children": [
              {
                "Node": "text",
                "Children": "?. 500 $1"
              }
            ]
          },
          {
            "Node": "text",
            "Children": ")\n\n        c = "
          },
          {
            "Node": "cuda",
            "Children": [
              {
                "Node": "text",
                "Children": "\n                "
              },
              {
                "Node": "uniforms",
                "Children": [
                  {
                    "Node": "text",
                    "Children": "\n                int t = 5;\n                "
                  }
                ]
              },
              {
                "Node": "text",
                "Children": "\n\n                "
              },
              {
                "Node": "buffers",
                "Children": [
                  {
                    "Node": "text",
                    "Children": "\n                int [] a = "
                  },
                  {
                    "Node": "python",
                    "Children": [
                      {
                        "Node": "text",
                        "Children": "a"
                      }
                    ]
                  },
                  {
                    "Node": "text",
                    "Children": "\n                "
                  }
                ]
              },
              {
                "Node": "text",
                "Children": "\n\n        "
              }
            ]
          },
          {
            "Node": "text",
            "Children": "\n\n        b = "
          },
          {
            "Node": "sql",
            "Children": [
              {
                "Node": "text",
                "Children": "\n            SELECT * FROM "
              },
              {
                "Node": "python",
                "Children": [
                  {
                    "Node": "text",
                    "Children": "a * a"
                  }
                ]
              },
              {
                "Node": "text",
                "Children": " t1 (a) WHERE a < 5\n        "
              }
            ]
          },
          {
            "Node": "text",
            "Children": "\n\n        len(b)\n    "
          }
        ]
      },
      {
        "Node": "text",
        "Children": ".\n\n"
      }
    ]
  },
  {
    "Node": "text",
    "Children": "\n\n\n\n\n"
  }
]