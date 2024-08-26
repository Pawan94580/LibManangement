// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract LibraryManagement {

    enum BookCategory { Fiction, NonFiction, Science, History }

    struct Book {
        address borrower;
        BookCategory category;
        string title;
        string author;
        uint publicationDate;
        uint borrowDate;
        uint dueDate;
        bool isBorrowed;
    }

    mapping(uint => Book) public books;
    uint public nextBookId = 1;

    event BorrowAttempt(address borrower, uint borrowDate, uint dueDate);

    function borrowBook(
        address _borrower,
        BookCategory _category,
        string memory _title,
        string memory _author,
        uint _publicationDate,
        uint _borrowDate,
        uint _dueDate
    ) public {
        emit BorrowAttempt(_borrower, _borrowDate, _dueDate);
        require(_borrowDate < _dueDate, "Borrow date must be before due date");

        books[nextBookId++] = Book(
            _borrower, 
            _category, 
            _title, 
            _author, 
            _publicationDate, 
            _borrowDate, 
            _dueDate, 
            true
        );
    }

    function returnBook(uint _bookId) public {
        Book storage book = books[_bookId];
        // Check if book exists and is borrowed
        require(book.borrower != address(0), "Book does not exist");
        require(book.isBorrowed, "Book is already returned");
        require(book.borrower == msg.sender, "Unauthorized");

        book.isBorrowed = false;
    }

    function viewBook(uint _bookId) public view returns (Book memory) {
        Book memory book = books[_bookId];
        // Check if book exists and is borrowed
        require(book.borrower != address(0), "Book does not exist");
        require(book.isBorrowed, "Book is not currently borrowed");
        require(book.borrower == msg.sender || msg.sender == address(0), "Unauthorized"); // Example: Allow anyone to view borrowed books

        return book;
    }

    function renewBook(uint _bookId, uint _newDueDate) public {
        Book storage book = books[_bookId];
        // Check if book exists and is borrowed
        require(book.borrower != address(0), "Book does not exist");
        require(book.isBorrowed, "Book is not currently borrowed");
        require(book.borrower == msg.sender, "Unauthorized");
        require(_newDueDate > book.dueDate, "New due date must be after current due date");

        book.dueDate = _newDueDate;
    }
}
