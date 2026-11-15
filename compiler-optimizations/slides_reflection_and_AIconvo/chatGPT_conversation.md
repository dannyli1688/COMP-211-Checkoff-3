# Explain compiler optimizations

> I would dead code elimination and loop optimizations. Give me a quick overview with a few examples as well as an outline to get everything finished before I present on monday the 16th.

<details><summary>6 previous messages</summary>

> I’m using the Superpowers startup and brainstorming skills to shape a short overview and a prep plan for Monday. I’ll check the workspace for any assignment requirements.
>
> <details><summary>Ran 2 commands</summary>
>
> - Ran `rg --files --hidden -g '!.git'`
> - Ran `Get-Content -LiteralPath 'C:/Users/tiger/.codex/plugins/cache/openai-curated-remote/superpowers/7.0.1/skills/using-superpowers/SKILL.md', 'C:/Users/tiger/.codex/plugins/cache/openai-curated-remote/superpowers/7.0.1/skills/brainstorming/SKILL.md'`
>
> </details>
>
> I found the Checkoff 3 instructions. I’ll use the PDF skill to check what your instructor expects for the presentation and any work due beforehand.
>
> <details><summary>Ran 6 commands, searched the web</summary>
>
> - Ran `Get-Content -LiteralPath 'C:/Users/tiger/.codex/plugins/cache/openai-primary-runtime/pdf/26.1105.12137/skills/pdf/SKILL.md', 'C:/Users/tiger/.codex/plugins/cache/openai-curated-remote/superpowers/7.0.1/skills/using-superpowers/references/codex-tools.md'`
> - Ran `Get-Command pdftotext, python, clang, gcc -ErrorAction SilentlyContinue | Select-Object Name, Source`
>
> Searched the web for `site:llvm.org LLVM passes dce loop invariant code motion loop unroll LLVM documentation`
>
> - Ran `python -c "import importlib.util; print([(m, bool(importlib.util.find_spec(m))) for m in ('pypdf','pdfplumber','fitz')])"`
> - Ran `& 'C:\Program Files\WindowsApps\OpenAI.CodexPrimaryRuntime.v26-1105-1297-0_26.1105.1297.0_x64__3k8sg7r9htsxt\dependencies\python\python.exe' -c "from pypdf import PdfReader; from pathlib import Path; p=next(Path.cwd().glob('*.pdf')); r=PdfReader(p); print(p); print(len(r.pages)); [print(f'PAGE {i}', x.extract_text(), sep='\n') for i,x in enumerate(r.pages, 1)]"`
> - Ran `& 'C:\Program Files\WindowsApps\OpenAI.CodexPrimaryRuntime.v26-1105-1297-0_26.1105.1297.0_x64__3k8sg7r9htsxt\dependencies\python\python.exe' -c "import sys; sys.stdout.reconfigure(encoding='utf-8'); from pypdf import PdfReader; from pathlib import Path; p=next(Path.cwd().glob('*.pdf')); r=PdfReader(p); [print(f'PAGE {i}', x.extract_text(), sep='\n') for i,x in enumerate(r.pages, 1)]"`
> - Ran `& 'C:\Program Files\WindowsApps\OpenAI.CodexPrimaryRuntime.v26-1105-1297-0_26.1105.1297.0_x64__3k8sg7r9htsxt\dependencies\python\python.exe' -c "import sys,re; sys.stdout.reconfigure(encoding='utf-8'); from pypdf import PdfReader; from pathlib import Path; r=PdfReader(next(Path.cwd().glob('*.pdf'))); [print(f'PAGE {i}', re.sub(r'\s+', ' ', r.pages[i-1].extract_text()).strip(), sep='\n') for i in range(6,11)]"`
>
> </details>
>
> The handout lists dead code elimination and loop optimizations as a valid pair. It also requires a prerecorded talk before your live slot, so I’ll build in time to record and submit it on Sunday.
>
> <details><summary>Ran a command, searched the web</summary>
>
> Searched the web for `https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html`
>
> - Ran `& 'C:\Program Files\WindowsApps\OpenAI.CodexPrimaryRuntime.v26-1105-1297-0_26.1105.1297.0_x64__3k8sg7r9htsxt\dependencies\python\python.exe' -c "from pypdf import PdfReader; from pathlib import Path; r=PdfReader(next(Path.cwd().glob('*.pdf'))); print([(i, a.get_object().get('/A',{}).get('/URI')) for i,p in enumerate(r.pages,1) for a in p.get('/Annots', [])])"`
>
> </details>

</details>

For your **Monday, Nov. 16 COMP 211 checkoff**, I’d focus on **dead code elimination** and **loop unrolling**. They’re a valid pair under Compiler Optimizations, and each gives you a short C example you can compare with the assembly your compiler generates. :codex-file-citation{path="C:/Users/tiger/Downloads/COMP 211 Checkoff 3/[Student] Checkoff 3 Instructions (1).pdf" purpose="source"}

## Quick overview

**Dead code elimination** removes work that can’t affect observable behavior. Here, the compiler can drop `x * x` because nothing uses the result and the calculation has no side effects. If you add `printf("%u\n", unused);`, the printed value now depends on that calculation. [LLVM’s dead code elimination documentation](https://llvm.org/docs/Passes.html#dce-dead-code-elimination)

```c
unsigned next(unsigned x) {
    unsigned unused = x * x;
    return x + 1;
}
```

**Loop unrolling** puts several iterations’ worth of work in one loop body. For a small loop with a known iteration count, the compiler can fully unroll it and remove the loop branch. The trade-off is that duplicating a larger loop body can increase code size. [LLVM’s loop unrolling documentation](https://llvm.org/docs/Passes.html#loop-unroll-unroll-loops)

```c
// Before
unsigned sum = 0;
for (int i = 0; i < 4; ++i)
    sum += a[i];

// Equivalent fully unrolled version
unsigned sum = a[0] + a[1] + a[2] + a[3];
```

**Try it yourself.** Use the same C compiler and target at `-O0`, `-O1`, `-O2`, and `-O3`. Look for where the multiply disappears and whether the branch that repeats the loop survives. Record the compiler version and what you actually see. An optimized build might use vector instructions for the sum, so check the assembly before calling it unrolling. [Compiler Explorer](https://godbolt.org/)

## Six-minute talk outline

| Time      | What to cover                                                                                                                                                |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 0:00–1:00 | Introduce yourself and explain what compiler optimization preserves. Ask the audience whether the compiler can erase `x * x`, then give them time to answer. |
| 1:00–2:30 | Walk through dead code elimination. Show the assembly difference and explain what changes when you print the value.                                          |
| 2:30–4:45 | Walk through loop unrolling. Compare the two C versions, then point out what your compiler actually emitted.                                                 |
| 4:45–6:00 | Share what surprised you across optimization levels and one thing you verified yourself.                                                                     |

Allow about **three minutes for Q&A**. The handout also asks you to ask one question after each classmate’s presentation. Create the slides yourself, using your own explanations and results.

## Finish by Sunday, Nov. 15

| When                    | Finish                                                                                                                                                                                                                                                                                                                                              |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Tue–Wed, Nov. 10–11** | Confirm your Monday slot and sign up **by Wednesday** if you haven’t already. Check that your subtopic is unique in your slot. Run the first compiler comparison and save the AI prompts that helped you explore it. [Checkoff sign-up sheet](https://docs.google.com/spreadsheets/d/15kf3JgA9ZkfUBFMFSb2LxU_HLtKkPkx3pHIJF1OgsbY/edit?usp=sharing) |
| **Thu–Fri, Nov. 12–13** | Finish both C experiments. Verify the outputs match across builds. For a timing comparison, use a larger workload, print a checksum at the end, and repeat the runs. Put your examples, reproduction steps, findings, and references in a **public GitHub repo**.                                                                                   |
| **Sat, Nov. 14**        | Make your slides, add them to the repo, and rehearse to **5–7 minutes**. Write your reflection with **two or three actual prompts**, what you tested or learned, what you’d do differently, and a permalink to the AI conversation.                                                                                                                 |
| **Sun, Nov. 15**        | Record the full talk using the same slides and material as the live version. Submit the video before your slot, and use Sunday as your target to submit the repo link and reflection too. Check that the video plays and the repo opens while signed out.                                                                                           |

> Please explain both of my topics in more detail such that I can be informed in my exploration. Also give me a guide on how to tests these specific topics in c.

<details><summary>2 previous messages</summary>

> I’ll explain what makes each optimization safe, then give you two C experiments where you can predict the result and check the generated assembly.
>
> <details><summary>Ran 4 commands, searched the web</summary>
>
> Searched the web for `site:gcc.gnu.org/onlinedocs/gcc Optimize Options -funroll-loops number of iterations determined -fno-tree-vectorize -fdce ...`
>
> <details><summary>Explored a file</summary>
>
> - Read `~/.codex/plugins/cache/openai-curated-remote/superpowers/7.0.1/skills/verification-before-completion/SKILL.md`
>
> </details>
>
> - Ran `Get-Command gcc, clang, clang-cl, wsl, cl, zig -ErrorAction SilentlyContinue | Select-Object Name, Source; Get-ChildItem 'C:\msys64\ucrt64\bin\gcc.exe', 'C:\msys64\mingw64\bin\gcc.exe', 'C:\Program Files\LLVM\bin\clang.exe', 'C:\Program Files\Microsoft Visual Studio' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName`
>
> Searched the web for `https://www.llvm.org/docs/Passes.html`
>
> - Ran `wsl --list --quiet`
> - Ran `$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'; if (Test-Path -LiteralPath $vswhere) { & $vswhere -all -find '**\clang.exe' }; Get-ChildItem 'C:\Rtools*', 'C:\MinGW*', 'C:\Strawberry\c\bin\gcc.exe', 'C:\Program Files\Git\mingw64\bin\gcc.exe' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName`
> - Ran `try { $r = Invoke-RestMethod -Uri 'https://godbolt.org/api/compilers/c' -Headers @{Accept = 'application/json'} -TimeoutSec 6; $r | Where-Object { $_.id -in @('cg143', 'cg142', 'cg122') } | Select-Object id, name } catch { $_.Exception.Message; exit 1 }`
>
> Searched the web for `site:gcc.gnu.org/onlinedocs/gcc developer options -fopt-info-loop-optimized loop unroll gcc`
>
> </details>

</details>

**Dead code elimination** asks whether a computation needs to happen at all. **Loop optimization** asks how to organize the work a loop needs to do. For your checkoff, I’d use **loop unrolling** as your main loop example because you can see the transformation in both C and assembly.

## Dead code elimination

A computation is _dead_ if its result can’t affect observable behavior and the computation itself has no observable effects. For example, if a function calculates `x * x` but only returns `x + 1`, the compiler can remove the multiplication. The line is reachable every time you call the function, but its result goes nowhere.

Compilers track which instructions produce values and which instructions use them. Removing one dead instruction can expose another. If `square = x * x` is used only to compute `adjusted = square + 7`, and `adjusted` is unused, removing the addition leaves the multiplication with no users either. Printing `square` changes that analysis because the program’s output now depends on the value. [LLVM’s dead code elimination documentation](https://llvm.org/docs/Passes.html#dce-dead-code-elimination)

## Loop optimization

**Unrolling** puts multiple iterations’ worth of work in one trip through the loop body. A sum unrolled by four processes four elements before jumping back to the top. With nine elements, that’s two groups of four and one leftover. The program still sums all nine elements. It can execute fewer loop-control instructions, at the cost of a larger loop body. With a small, fixed iteration count, the compiler can sometimes unroll the entire loop and eliminate the loop branch. [GCC’s optimization options](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html)

Two related techniques will help you interpret what you see:

- **Loop-invariant code motion** moves a calculation outside the loop when its inputs stay the same and moving it is safe. For example, an unsigned `width * height` can be computed once if neither value changes. Division is trickier: moving it before the loop could introduce division by zero on a path where the loop originally ran zero times. [LLVM’s loop-invariant code motion documentation](https://llvm.org/docs/Passes.html#licm-loop-invariant-code-motion)
- **Vectorization** uses one instruction to operate on several elements at once. Unrolling can use several ordinary scalar instructions in one trip through the loop. A compiler can also combine the techniques, so disable vectorization for your first unrolling experiment. [GCC’s optimization options](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html)

## Test both in C

Save the functions as `examples.c`. The two `next` functions return the same value. Only one prints the square. `sum` takes its length as an argument so you can test different iteration counts.

```c
#include <stddef.h>
#include <stdio.h>

unsigned next_unused(unsigned x) {
    unsigned square = x * x;
    (void)square;  // Explicitly discard the value.
    return x + 1u;
}

unsigned next_logged(unsigned x) {
    unsigned square = x * x;
    printf("square = %u\n", square);
    return x + 1u;
}

unsigned sum(const unsigned *values, size_t count) {
    unsigned total = 0;
    for (size_t i = 0; i < count; ++i) {
        total += values[i];
    }
    return total;
}
```

**1. Check the output.** Save this as `check.c`. Keeping the driver in a separate file lets you compile the functions without giving the optimizer the driver’s constant inputs.

```c
#include <assert.h>
#include <stddef.h>
#include <stdio.h>

unsigned next_unused(unsigned x);
unsigned next_logged(unsigned x);
unsigned sum(const unsigned *values, size_t count);

int main(void) {
    const unsigned values[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};

    unsigned plain = next_unused(7u);
    unsigned logged = next_logged(7u);
    assert(plain == 8u && logged == 8u);

    for (size_t n = 0; n <= sizeof values / sizeof values[0]; ++n) {
        unsigned expected = (unsigned)(n * (n + 1) / 2);
        assert(sum(values, n) == expected);
    }

    puts("Checks passed.");
    return 0;
}
```

Run these in a Linux shell with GCC. Each build should print `square = 49` followed by `Checks passed.` The sum checks cover zero iterations and lengths that leave leftovers after unrolling.

```bash
gcc -O0 examples.c check.c -o check-O0
gcc -O2 examples.c check.c -o check-O2
gcc -O2 -fno-tree-vectorize -funroll-loops examples.c check.c -o check-unrolled

./check-O0
./check-O2
./check-unrolled
```

**2. Look for dead code elimination.** The `-S` flag saves assembly as text.

```bash
gcc -O0 -S examples.c -o examples-O0.s
gcc -O2 -S examples.c -o examples-O2.s
```

Find `next_unused` and `next_logged` in both files. Predict that the optimized `next_unused` will have no multiply, while `next_logged` will still compute the square and call `printf`. On x86, look for `imul` or `imull`. If the multiply is already absent at `-O0`, record that result and use the two functions to show what changes when the square feeds observable output.

**3. Look for loop unrolling.** Keep the optimization level fixed and compare the two versions of `sum`.

```bash
gcc -O2 -fno-tree-vectorize -fno-unroll-loops -S examples.c -o scalar.s
gcc -O2 -fno-tree-vectorize -funroll-loops -S examples.c -o unrolled.s
```

Find the branch that jumps back to repeat the loop. Count how many array elements the main loop processes before that branch. Also look for code that handles extra elements when the length isn’t a multiple of the unroll factor. GCC chooses the factor, so record what you observe. You can also add `-fopt-info-loop-optimized` to ask GCC for optimization remarks. [GCC’s optimization remarks documentation](https://gcc.gnu.org/onlinedocs/gcc/Developer-Options.html)

GCC was unavailable in this workspace, so the assembly descriptions are predictions for you to check. If you don’t have GCC locally, paste `examples.c` into Compiler Explorer, choose **C** and **GCC**, and put the flags in the compiler options box. For your write-up, save the compiler version, flags, and a few lines of assembly that show each change. Matching outputs check correctness for your test inputs. Assembly shows what changed, and repeated timings on a larger input can tell you whether it mattered for performance. [Compiler Explorer](https://godbolt.org/)

The sign-up link I gave earlier had a typo. Here’s the corrected [Checkoff 3 sign-up sheet](https://docs.google.com/spreadsheets/d/15kf3JgA9ZkfufBMFSb2LxU_HLtKkPkx3pHIJF1OgsbY/edit?usp=sharing).

> can you guide me on how to make the repository in vscode

<details><summary>2 previous messages</summary>

> I’ll check what’s already in your Checkoff 3 folder and verify the VS Code steps for publishing a public GitHub repository.
>
> <details><summary>Ran a command, searched the web</summary>
>
> Searched the web for `site:code.visualstudio.com docs sourcecontrol overview publish to GitHub public repository initialize repository VS Code Source Control`
>
> - Ran `rg --files --hidden -g '!.git' -g '!.git/**'; git status --short --branch`
>
> </details>

</details>

Create a folder named `compiler-optimizations` inside your **COMP 211 Checkoff 3** folder, then publish it from VS Code. Your Checkoff 3 folder currently contains only the assignment PDF. Using a subfolder keeps the public repo focused on your work.

### 1. Set up the project in VS Code

Go to **File → Open Folder** and open `compiler-optimizations`. In the Explorer sidebar, create `README.md` and add your C experiments when they’re ready. You can publish the README first and add the other files later.

| File                          | What to include                                                                                   |
| ----------------------------- | ------------------------------------------------------------------------------------------------- |
| `README.md`                   | What you explored, the GCC commands to reproduce it, what you observed, and links to your sources |
| `examples.c` and `check.c`    | Your dead code elimination and loop unrolling experiments and the driver that checks their output |
| `slides.pdf` or `slides.pptx` | The slides you make for your checkoff                                                             |

### 2. Make your first commit

1. Press **Ctrl+Shift+G** to open **Source Control**.
2. Click **Initialize Repository**.
3. Under **Changes**, hover over each file you want to include and click **+** to stage it.
4. Type a commit message such as `Start compiler optimization project` and click **Commit**. This saves a snapshot in Git on your computer. [VS Code Source Control quickstart](https://code.visualstudio.com/docs/sourcecontrol/quickstart)

If Git asks for your author information, open **Terminal → New Terminal** in VS Code and run these commands with your own details, then retry the commit.

```powershell
git config user.name "Your Name"
git config user.email "Your GitHub email or GitHub noreply address"
```

### 3. Publish it to GitHub

1. Press **Ctrl+Shift+P**, type **Publish to GitHub**, and select the command.
2. Sign in to GitHub if prompted.
3. Name the repo `comp211-compiler-optimizations` and choose **Publish to GitHub public repository**. This creates the GitHub repo and uploads your commit. [VS Code guide to publishing on GitHub](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes#_publish-to-github)
4. Open the GitHub repo URL in a private browser window. If you can see your README while signed out, the link is ready to share with your TA.

When you add your experiments or slides, **stage → commit → push** from Source Control. You’ll keep using the same GitHub link.

> What specifically is "assembly difference" in dead code elimination, and explain the conditions for dead code elimination (for example how big or small does the loop have to be). Explain both concepts with examples.

<details><summary>2 previous messages</summary>

> I’ll show which assembly instructions can disappear, then explain what makes a whole loop removable and how that differs from unrolling.
>
> <details><summary>Ran a command, searched the web</summary>
>
> Searched the web for `site:llvm.org/docs/Passes.html dce dead instructions loop deletion computable trip counts volatile loop unroll ...`
>
> - Ran `rg --files --hidden -g '!.git' -g '!.git/**' -g '*.c' -g '*.s' -g '*.asm'; Get-Command gcc, clang, cl, tcc -ErrorAction SilentlyContinue | Select-Object Name, Source`
>
> Searched the web for `https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf`
>
> </details>

</details>

In your checkoff, **“assembly difference” means pointing to the machine instructions the compiler stopped generating**. For dead code elimination, you might show that the multiply disappears while the function still returns the same value. For loop unrolling, you might show that the backward jump disappears while the array reads and additions remain.

## 1. Dead code elimination

```c
unsigned next(unsigned x) {
    unsigned square = x * x;
    (void)square;
    return x + 1u;
}
```

Compare the assembly at `-O0` and `-O2`. Here’s a simplified x86-64 example, with register setup and stack instructions omitted:

```asm
; -O0, with x in eax at the multiply
imul eax, eax       ; compute x * x
; ... save square and reload x ...
add  eax, 1         ; compute x + 1
ret

; -O2, with x in edi on entry
lea  eax, [rdi+1]   ; compute x + 1
ret
```

**The evidence is the missing `imul`.** `lea` is doing the arithmetic for `x + 1` here. It doesn’t read memory. Exact instructions vary by compiler and target, so use your own output in the presentation.

The compiler can remove the multiplication because its result feeds neither the return value nor any observable effect. Try replacing `(void)square;` with `printf("%u\n", square);` and adding `#include <stdio.h>`. Now the output depends on the square, so the compiler must preserve that behavior. It can still choose how to compute the value. [LLVM’s dead code elimination documentation](https://llvm.org/docs/Passes.html#dce-dead-code-elimination)

## 2. When can the compiler delete a whole loop?

**There’s no minimum or maximum iteration count for dead loop deletion.** The compiler needs to establish that the loop’s work has no observable effect, no result needed afterward, and that skipping it preserves control flow. Termination matters because deleting a loop that would run forever could let later code execute. C lets compilers assume termination for some loops under specific conditions. [LLVM’s dead loop deletion documentation](https://llvm.org/docs/Passes.html#loop-deletion-delete-dead-loops), [C11 draft, §6.8.5](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf#page=168)

```c
unsigned discard_work(unsigned n) {
    unsigned total = 0;
    for (unsigned i = 0; i < n; ++i) {
        total += i;
    }
    return 7u;
}
```

This loop terminates for every `unsigned n`. Its only work updates a local variable whose value is discarded, so the compiler can emit just `mov eax, 7` and `ret`. It can do that even when `n` is a runtime input. As a control, change `total` to `volatile unsigned total`. Each iteration now performs a volatile read and write that the compiler must preserve, even though the function still returns `7`.

## 3. How loop unrolling looks different

```c
unsigned sum_four(const unsigned *a) {
    unsigned total = 0;
    for (unsigned i = 0; i < 4; ++i) {
        total += a[i];
    }
    return total;
}
```

Here the caller needs the sum. A fully unrolled version does the equivalent of `return a[0] + a[1] + a[2] + a[3];`. In scalar assembly, look for accesses to all four elements and the absence of a backward jump. **Loop size matters for unrolling** because copying the body can make the generated code larger. A compiler might fully unroll four iterations and only partially unroll a longer loop. There’s no universal cutoff. [GCC’s loop optimization options](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#index-funroll-loops)

To compare all three examples, save them in `examples.c` and run these with x86-64 GCC. The second command disables vectorization so the array operations are easier to follow.

```bash
gcc -O0 -S -masm=intel examples.c -o before.s
gcc -O3 -fno-tree-vectorize -S -masm=intel examples.c -o after.s
```

For your slides, highlight **the missing multiply** in `next`, **the missing body and jump** in `discard_work`, and **the surviving array work** in `sum_four`. A missing loop branch alone can’t tell you which optimization happened.

> does the logged function have higher memory usage and runtime?

**Runtime is usually higher.** In your example, `next_unused` can compile down to computing `x + 1` and returning. `next_logged` also computes `x * x` and calls `printf`. Formatting and writing the number typically costs far more than the multiplication.

**Memory usage depends on what you measure.** The compiler can keep `square` in a CPU register, so the variable itself may take zero stack bytes. The `printf` call can add temporary stack usage and may use a standard I/O buffer. The exact amount depends on the compiler, platform, and C library.

For your checkoff, compare the assembly to see whether the multiply survives. A runtime comparison of these two functions would mostly measure the cost of logging.

> can you give me a run down on the gcc compiler optimization flags, include which ones are the most common, what they do, and the drawbacks of higher optimization levels

<details><summary>2 previous messages</summary>

> I’ll check GCC’s documentation for the standard optimization levels and connect them to your dead code elimination and loop unrolling experiments.
>
> <details><summary>Searched the web</summary>
>
> Searched the web for `site:gcc.gnu.org/onlinedocs/gcc Optimize Options -O0 -O1 -O2 -O3 -Og -Os -Oz -Ofast GCC current manual ...`
>
> Searched the web for `site:gcc.gnu.org onlinedocs gcc debugging options -g -O variables do not exist optimized`
>
> Searched the web for `site:gcc.gnu.org GCC 12 changes vectorization -O2 very-cheap cost model -O3 dynamic ...`
>
> Searched the web for `site:gcc.gnu.org GCC signed overflow undefined behavior optimizers -fstrict-overflow -fwrapv optimization signed overflow assumes`
>
> </details>

</details>

**`-O0` is the default, `-Og -g` is GCC’s debugging recommendation, and `-O2` is a common starting point for release builds.** Try `-O3` when runtime matters and you can benchmark the result. Each level enables a bundle of compiler optimizations, and the exact bundle depends on your GCC version and target. [GCC optimization options](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html)

## The main GCC optimization flags

| Flag                    | What it does                                                                                                   | When you’d use it                                                             |
| ----------------------- | -------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| **`-O0`**               | Disables most optimization passes. Usually builds quickly and keeps the generated code closer to the source.   | An assembly baseline for your checkoff.                                       |
| **`-Og`**               | Enables optimizations selected to preserve a useful debugging experience.                                      | Pair it with `-g` to step through code and inspect variables in a debugger.   |
| **`-O1`** or **`-O`**   | Applies basic optimizations, including dead code elimination, while limiting compile-time cost.                | See which changes already happen at the first optimization level.             |
| **`-O2`**               | Adds more optimizations, including more inlining and, since GCC 12, conservative vectorization.                | A general-purpose release build.                                              |
| **`-O3`**               | Builds on `-O2` with more aggressive loop transformations and a more permissive vectorization cost model.      | Performance experiments on code that spends a lot of time in loops.           |
| **`-Os`** and **`-Oz`** | Prioritize smaller generated code. `-Oz` pursues size more aggressively.                                       | When executable size matters, such as on an embedded device.                  |
| **`-Ofast`**            | Adds flags to `-O3` that relax some language guarantees, including floating-point rules through `-ffast-math`. | When you’ve checked that your program can tolerate those changed assumptions. |

[GCC optimization levels](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html) · [GCC 12 vectorization change](https://gcc.gnu.org/gcc-12/changes.html)

## Drawbacks of higher optimization levels

- **Builds can take longer and use more compiler memory.** GCC performs more analysis and transformations during compilation.
- **Generated code can grow.** Inlining and loop unrolling can duplicate instructions. A larger instruction footprint can put more pressure on the CPU’s instruction cache, so `-O3` can be slower than `-O2` on a particular workload. [GCC’s loop unrolling documentation](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#index-funroll-loops)
- **Debugging gets harder.** A local variable may show up as `optimized out`, and stepping can appear to skip lines because GCC removed or moved their instructions. `-g` adds debug information at any optimization level. [GCC debugging options](https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html)

## What to look for in your checkoff

For **dead code elimination**, compare `next_unused` at `-O0` and `-O1` first. GCC already enables `-ftree-dce` at `-O1`, so the unused multiply can disappear before you reach `-O2`. Check whether `next_logged` still computes the square for `printf`. [GCC’s dead code elimination flag](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#index-ftree-dce)

For **loop unrolling**, compare these two builds at the **same** optimization level. `-S` writes assembly, and `-fno-tree-vectorize` makes the scalar loop easier to read. Count how many array elements the main loop processes before its backward jump.

```bash
gcc -O2 -fno-tree-vectorize -fno-unroll-loops -S examples.c -o scalar.s
gcc -O2 -fno-tree-vectorize -funroll-loops    -S examples.c -o unrolled.s
```

`-O3` can fully unroll some small loops even without `-funroll-loops`. Use the assembly to show what GCC emitted, and use repeated timings on the same input if you want to claim a speedup. [GCC loop optimization options](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#index-funroll-loops)
