<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Student;
use Illuminate\Http\Request;

class StudentController extends Controller
{
    public function index()
    {
        return response()->json(Student::orderBy('id')->get(), 200);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'course' => 'required|string|max:255',
        ]);

        return response()->json(Student::create($data), 201);
    }

    public function show(Student $student)
    {
        return response()->json($student, 200);
    }

    public function update(Request $request, Student $student)
    {
        $data = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'course' => 'sometimes|required|string|max:255',
        ]);

        $student->update($data);

        return response()->json($student, 200);
    }

    public function destroy(Student $student)
    {
        $student->delete();

        return response()->noContent(); // 204
    }
}